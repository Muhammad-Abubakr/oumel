import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/user.dart' as model;

part 'database_user_state.dart';

class DatabaseUserCubit extends Cubit<DatabaseUserState> {
  /* Database */
  final DatabaseReference _users = FirebaseDatabase.instance.ref('users');

  /* Constructor */
  DatabaseUserCubit() : super(const DatabaseUserInitial(user: null));

  /* Create User
    Creating a user on the time of registration.
    - If the User is signed in, means that the User must have 
    had registered but does not gurantee if the user is ANONYMOUS
    - In that case we check if the user is not anonymous and proceed
    (if the user was anonymous do nothing, let the function complete)
  */
  void createUser(DateTime dob, {String? about}) async {
    /* get the user instance */
    final user = FirebaseAuth.instance.currentUser;

    /* Create the ref for user in the real time database */
    final DatabaseReference meRef = _users.child(user!.uid);

    /* updated user */
    final model.User newUser = model.User(
      fName: user.displayName!.split(' ')[0],
      lName: user.displayName!.split(' ').sublist(1).join(' '),
      dob: dob,
      email: user.email ?? '',
      phoneNumber: user.phoneNumber ?? '',
      photoURL: user.photoURL ?? '',
      about: about ?? 'Write something about yourself here...',
      uid: user.uid,
    );

    // Update the User in the database.
    await meRef.set(newUser.toJson());

    // once we have our user, update the cubit
    emit(DatabaseUserUpdate(user: newUser));
  }

  /* Initialize the cubit data when user signs in*/
  void initialize() async {
    /* get the user instance */
    final user = FirebaseAuth.instance.currentUser;

    /* Get the ref for user in the real time database */
    final DatabaseReference meRef = _users.child(user!.uid);

    /* Parse the user value (since user is signed in that means
     he is present in database and hence not null */

    final DataSnapshot me = await meRef.get();

    final parsedUser = model.User.fromJson(me.value.toString());

    // emit the user
    emit(DatabaseUserUpdate(user: parsedUser));
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
  void dispose() async {}
}
