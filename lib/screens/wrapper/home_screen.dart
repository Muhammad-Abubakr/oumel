import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oumel/blocs/user/user_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () => context.read<UserBloc>().add(UserSignOut()),
          child: const Text('Sign Out')),
    );
  }
}
