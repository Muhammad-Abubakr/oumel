part of 'user_bloc.dart';

/* Implementing an Enum to reflect the state of UserBloc
   This helps in implementing features like loading widgets, error dialogs etc.
 */
enum UserStates {
  initialized, // user has signed in for first time
  updated, // any of the user attributes have been updated
  signedOut, // user has signed out
  anonLogin, // user is logging in as guest
  signedIn, // user has signed up before and signing in
  codeSent, // sms otp sent to the phone number for verification
  verified, // phone number verified
  processing, // tells the application about an asynchronous event
  registered, // tells the application that user has been registered
  error, // tells the application that there was an error while processing the request
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
