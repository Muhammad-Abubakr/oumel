import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/user/user_bloc.dart';
import '../wrapper/wrapper.dart';
import 'authentication.dart';

class LoginScreen extends StatefulWidget {
  // route name
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        switch (state.status) {
          case UserStates.signedIn:
            // popping the loading indicator
            Navigator.of(context)
                .popUntil(ModalRoute.withName(AuthenticationScreen.routeName));

            // pushing the Wrapper on Stack
            Navigator.of(context).pushReplacementNamed(Wrapper.routeName);
            break;
          case UserStates.error:
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Sign in'),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 0.1.sw,
                right: 0.1.sw,
                top: 0.1.sh,
                bottom: 0.1.sh,
              ),
              child: Column(
                children: [
                  /* Logo */
                  Image.asset('assets/oumel.png'),
                  SizedBox(height: 256.h),

                  /* Text Fields */
                  Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      SizedBox(height: 48.h),
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      SizedBox(height: 164.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserBloc>().add(UserSignInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                        ),
                        child: const Text('Sign in'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
