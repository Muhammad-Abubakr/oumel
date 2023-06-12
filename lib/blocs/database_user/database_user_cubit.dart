import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/user.dart' as model;

part 'database_user_state.dart';

class DatabaseUserCubit extends Cubit<DatabaseUserState> {
  /* Database */
  final DatabaseReference _users = FirebaseDatabase.instance.ref('users');

  // Streams
  late final StreamSubscription _streamSubscription;

  /* Constructor */
  DatabaseUserCubit() : super(const DatabaseUserInitial(user: null));

  /* Initialize 
    Getting the user from the Realtime Database onAuthState,
    When we have a User and not signed out.
    - If the User is signed in, means that the User must have 
    had registered but does not gurantee if the user is ANONYMOUS
    - In that case we check if the user is not anonymous and proceed
    (if the user was anonymous do nothing, let the function complete)
  */
  void initialize() {
    _streamSubscription = FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null && !user.isAnonymous) {
        /* get the user from the real time database */
        final DataSnapshot me = await _users.child(user.uid).get();

        /* Parse the user */
        final model.User databaseUser = model.User.fromJson(me.value.toString());

        /* updated user */
        final model.User updatedUser = model.User(
          fName: user.displayName!.split(' ')[0],
          lName: user.displayName!.split(' ').sublist(1).join(' '),
          dob: databaseUser.dob,
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          photoURL: user.photoURL ?? '',
          about: databaseUser.about,
          uid: user.uid,
        );

        // get the user ref
        final userRef = _users.child(user.uid);

        // Update the User in the database.
        await userRef.set(updatedUser.toJson());

        // once we have our user, update the cubit
        emit(DatabaseUserUpdate(user: updatedUser));
      }
    });
  }

  /* Update the User About */
  void updateAbout(String about) async {
    // since our update about is in edit profile page and
    // it is only accessible when we have a user signed in
    // we will access the user in our state, and use the
    // copyWith constructor to update the about and then
    final updatedUser = state.user!.copyWith(about: about);

    // get the user ref
    final userRef = _users.child(state.user!.uid);

    // Update the User in the database.
    await userRef.set(updatedUser.toJson());

    // emit the user update
    emit(DatabaseUserUpdate(user: updatedUser));
  }

  /* Dispose */
  void dispose() async {
    /* Cancelling the Streams */
    await _streamSubscription.cancel();
  }
}
