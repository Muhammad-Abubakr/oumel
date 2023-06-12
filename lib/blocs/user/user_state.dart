part of 'user_bloc.dart';

/* Implementing an Enum to reflect the state of UserBloc
   This helps in implementing features like loading widgets, error dialogs etc.
 */
enum UserStates {
  updated,
  signedOut,
  signedIn,
  codeSent,
  verified,
  processing,
  registered,
  error,
}

/* extending package Equatable for deep comparision between objects,
   incase if we used `extends` we can also use EquatableMixin using `with`
 */
@immutable
abstract class UserState extends Equatable {
  // Firebase User instance
  final User? user;
  final UserStates status;
  final FirebaseAuthException? error;

  // Constructor for UserState,
  // takes in one Named Parameter: user of type FirebaseAuth.User
  const UserState({required this.user, required this.status, this.error});

  @override
  List<Object?> get props => [user, status, error];
}

/* Initial State of the User Bloc */
class UserInitial extends UserState {
  const UserInitial({User? user, required UserStates state, FirebaseAuthException? error})
      : super(user: user, status: state, error: error);
}

/* Updated State of the User Bloc */
class UserUpdate extends UserState {
  const UserUpdate({User? user, required UserStates state, FirebaseAuthException? error})
      : super(user: user, status: state, error: error);
}
