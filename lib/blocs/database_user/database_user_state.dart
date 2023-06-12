part of 'database_user_cubit.dart';

abstract class DatabaseUserState extends Equatable {
  /* User Model State */
  final model.User? user;

  const DatabaseUserState({required this.user});

  @override
  List<Object?> get props => [user];
}

class DatabaseUserInitial extends DatabaseUserState {
  const DatabaseUserInitial({required super.user});
}

class DatabaseUserUpdate extends DatabaseUserState {
  const DatabaseUserUpdate({required super.user});
}
