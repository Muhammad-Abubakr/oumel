import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oumel/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user.dart' as model;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  /* ================================ Fields ================================ */
  /* Firebase Storage Instance Reference (root) */
  final storage = FirebaseStorage.instance.ref();
  /* Firebase Realtime database Instance Reference (root) */
  final database = FirebaseDatabase.instance.ref();
  /* linking to our service cursor `AuthService` we created under /lib/srevices/auth.dart
  this will be used to call all the intermediary service calls to FirebaseAuth */
  late final AuthService _auth;

  /* ================================ UserBloc constructor ================================ 

     Extends the Bloc with event type UserEvent and state type UserState
     {may need to look into dart streams for a better understanding of how it works}
     [https://www.youtube.com/watch?v=w6XWjpBK4W8&list=PLptHs0ZDJKt_T-oNj_6Q98v-tBnVf-S_o]

     Above is the link to a great playlist for flutter_bloc by flutterly
   */
  UserBloc() : super(const UserInitial(state: UserStates.signedOut)) {
    _auth = AuthService();

    // =============== Subscribing to Firebase User Stream ================ //
    _auth.subscribe.listen((element) => add(_UserUpdateEvent(element)));

    // =============== Hooking Handlers ================ //
    // PRIVATE
    on<_UserUpdateEvent>(_subscriptionHandler);

    // CLIENT
    on<UserSignInAnonymously>(_signInUserAnonHandler);
    on<UserSignInWithGoogle>(_signInWithGoogle);
    on<RegisterUserWithEmailAndPassword>(_registerUserWithEmailAndPassHandler);
    on<UserSignInWithEmailAndPassword>(_signInUserWithEmailAndPassHandler);
    on<UserDisplayNameUpdate>(_userDisplayNameUpdateHandler);
    on<UserSignOut>(_signOutUserHandler);
    on<UserPfpUpdate>(_userPfpUpdateHandler);
  }

  /* 
    Subscription Handler
   */
  FutureOr<void> _subscriptionHandler(_UserUpdateEvent event, Emitter<UserState> emit) {
    // updates the Bloc about the change in user state from the firebase subscription
    if (kDebugMode) {
      print(event.user);
    }

    // If the user has signed out
    if (event.user == null) {
      emit(UserUpdate(
        user: event.user,
        state: UserStates.signedOut,
      ));
      // otherwise the user must have signed in
    } else {
      emit(UserUpdate(
        user: event.user,
        state: UserStates.signedIn,
      ));
    }
  }

  // ========================= Event Handlers ========================== //

  /*  
  1). Sign in Anonymously 
    i - This handler utilizes the intermediary service function `signInAnon` -> User?
        we described under /lib/services/auth.dart. 

    ii - on Error emits the state update with error status and error message for use on client side.
        handles FirebaseAuthException: 
      * operation-not-allowed 
      ? when anon sign in is not enabled in firebase

    returns : void

  */
  FutureOr<void> _signInUserAnonHandler(
      UserSignInAnonymously event, Emitter<UserState> emit) async {
    try {
      emit(UserUpdate(user: state.user, state: UserStates.processing));
      // i).
      await _auth.signInAnon();

      // ii).
    } on FirebaseAuthException catch (error) {
      emit(UserUpdate(state: UserStates.error, error: error));
    }
  }

  /* 
  2). LogOut the User 
      Logs out the current User that is signed in to our firebase auth instance

    i- Utilizes service function `logout` -> bool

    ii -  on Error emits the state update with error status and error message for use on client side.

    returns bool
  */
  FutureOr<void> _signOutUserHandler(UserSignOut event, Emitter<UserState> emit) async {
    emit(UserUpdate(state: UserStates.processing, user: state.user));

    try {
      // i.
      await _auth.logout();

      // ii.
    } on FirebaseAuthException catch (e) {
      emit(UserUpdate(state: UserStates.error, error: e));
    }
  }

  /* 
    # Register User With Email And Password Handler
    - utilizes the service function `registerWithEmailAndPassword` -> User?

     A [FirebaseAuthException] maybe thrown with the following error code:
     * email-already-in-use
     * invalid-email
     * operation-not-allowed:
      ? Thrown if email/password accounts are not enabled. Enable 
      ? email/password accounts in the Firebase Console, under the Auth tab.
     *  weak-password:
      ? Thrown if the password is not strong enough.
   */
  FutureOr<void> _registerUserWithEmailAndPassHandler(
      RegisterUserWithEmailAndPassword event, Emitter<UserState> emit) async {
    // Input Validation Can be done here and if not valid can be thrown a custom error
    // which on frontend can be caught and handeled

    try {
      emit(UserUpdate(user: state.user, state: UserStates.processing));

      // i.
      if (kDebugMode) {
        print('Registering user with: \nEmail: ${event.email}\nPass: ${event.password}\n');
      }

      User? user = await _auth.registerWithEmailAndPassword(event.email, event.password);

      if (user != null) {
        emit(UserUpdate(user: state.user, state: UserStates.registered));

        /* Update Display Name and PhotoURL */

        /* Storing the image */
        // Getting the reference
        final imageRef = storage.child('pfps/${user.uid}');

        imageRef.putFile(File(event.xFile.path)).whenComplete(() async {
          /* Updating the user */
          await user.updateDisplayName('${event.firstName} ${event.lastName}');
          await user.updatePhoneNumber(event.phoneAuthCredential);
          await user.updatePhotoURL(await imageRef.getDownloadURL());

          /* Add the User to users collection in realtime database */
          final usersRef = database.child('users/${user.uid}');

          /* Create user at the usersRef */
          await usersRef.set(
            model.User(
              fName: event.firstName,
              lName: event.lastName,
              email: event.email,
              dob: event.dob,
              phoneNumber: event.phoneNumber,
              photoURL: await imageRef.getDownloadURL(),
              uid: user.uid,
            ).toJson(),
          );
        });
      }

      // Incase of error while registering on Signing in
    } on FirebaseAuthException catch (e) {
      emit(UserUpdate(state: UserStates.error, error: e));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /* 
    # Signs in User With Email And Password Handler
    - utilizes the service function `signInWithEmailAndPassword` -> User?

    Handlers FirebaseAuthException:
    * invalid-email:
      ? Thrown if the email address is not valid.
    * user-disabled:
      ? Thrown if the user corresponding to the given email has been disabled.
    * user-not-found:
      ? Thrown if there is no user corresponding to the given email.
    * wrong-password:
      ? Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
  */
  FutureOr<void> _signInUserWithEmailAndPassHandler(
      UserSignInWithEmailAndPassword event, Emitter<UserState> emit) async {
    emit(UserUpdate(user: state.user, state: UserStates.processing));

    try {
      if (kDebugMode) {
        print('Signing in user with: \nEmail: ${event.email}\nPass: ${event.password}\n');
      }
      // i.
      await _auth.signInWithEmailAndPassword(event.email, event.password);

      // ii. Incase of error while registering on Signing in
    } on FirebaseAuthException catch (e) {
      emit(UserUpdate(state: UserStates.error, error: e));
    }
  }

  /* 
    # User Sign-In With Google handler

    Handlers FirebaseAuthException:
    * User-Disabled
      ? thrown if the relevant authentication method is not enabled
   */
  FutureOr<void> _signInWithGoogle(UserSignInWithGoogle event, Emitter<UserState> emit) async {
    try {
      emit(UserUpdate(user: state.user, state: UserStates.processing));
      // i).
      await _auth.signInWithGoogle();

      // ii).
    } on FirebaseAuthException catch (error) {
      emit(UserUpdate(state: UserStates.error, error: error));
    }
  }

  /* 
    # Updates User photoURL in Firebase User instance

    i). Replaces the photo file in the storage path for the user
    ii). Updates the photo url in the user instance of firebase
    iii). catches errors incase any
   */
  FutureOr<void> _userPfpUpdateHandler(UserPfpUpdate event, Emitter<UserState> emit) async {
    emit(UserUpdate(user: FirebaseAuth.instance.currentUser, state: UserStates.processing));
    try {
      // i).

      /* Update  PhotoURL */

      /* Storing the image */
      // Getting the reference (child) to the user uid
      final imageRef = storage.child('pfps/${state.user?.uid}');

      /// updating the photoURL
      // deleting
      try {
        await imageRef.delete();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      // updating
      final imageSnapshot = await imageRef.putFile(File(event.xFile.path));

      /* Updating the user in firebase */
      await FirebaseAuth.instance.currentUser
          ?.updatePhotoURL(await imageSnapshot.ref.getDownloadURL());

      /* Updating reference to user profile pic in the users collection in database */
      // getting the reference
      // // TODONE: REMOVE ANONYMOUS CHECK WHEN LOGGING IN WITH USER
      final userRef = database.child('users/${state.user?.uid}');

      // parsing and updating the user modal
      final user = model.User.fromJson((await userRef.get()).value.toString());

      final updatedUser = user.copyWith(photoURL: await imageSnapshot.ref.getDownloadURL());

      // setting the new model for the user in the database
      await userRef.set(updatedUser.toJson());

      // emit the user state, that the user is updated
      emit(UserUpdate(user: FirebaseAuth.instance.currentUser, state: UserStates.updated));
      // ii).
    } on FirebaseAuthException catch (error) {
      emit(UserUpdate(state: UserStates.error, error: error));
    }
  }

  /* Display Name update handler */
  FutureOr<void> _userDisplayNameUpdateHandler(
      UserDisplayNameUpdate event, Emitter<UserState> emit) async {
    // tell the application we are processing the request
    emit(UserUpdate(state: UserStates.processing, user: state.user));

    try {
      // update the display name of firebase auth user
      await state.user?.updateDisplayName(event.name);

      //  get the latest user change
      final user = FirebaseAuth.instance.currentUser;

      // update the bloc state
      emit(UserUpdate(state: UserStates.updated, user: user));
    } on FirebaseAuthException catch (e) {
      // tell the application an error has occured
      emit(UserUpdate(state: UserStates.error, error: e));
    }
  }
}
