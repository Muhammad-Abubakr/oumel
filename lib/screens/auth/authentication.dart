import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/screens/auth/login_screen.dart';
import 'package:oumel/screens/auth/register_screen.dart';
import 'package:oumel/screens/wrapper/wrapper.dart';

import '../../blocs/user/user_bloc.dart';

class AuthenticationScreen extends StatelessWidget {
  // Route Name
  static const routeName = '/authentication';

  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
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
            // First Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.error?.message}'),
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ),
            ));
            break;
          /* Processing Indicator */
          case UserStates.processing:
            Navigator.of(context).push(DialogRoute(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                  );
                }));

            break;
          default:
            break;
        }
      },
      builder: (context, state) => SingleChildScrollView(
        child: Container(
          height: 1.sh,
          margin: EdgeInsets.symmetric(vertical: 20.h),
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /* Logo */
              Image.asset('assets/oumel.png'),

              /* Buttons (Sign In, Register, Guest) */
              Column(
                children: [
                  /* Sign In */
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: const Text('Sign in'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                      ),
                    ),
                    onPressed: () => context.read<UserBloc>().add(UserSignInAnonymously()),
                    child: const Text('Continue as guest'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
