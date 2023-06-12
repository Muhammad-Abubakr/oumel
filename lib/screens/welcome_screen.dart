import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/screens/auth/authentication.dart';

class WelcomeScreen extends StatelessWidget {
  // Route Name
  static const routeName = '/welcome';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/oumel.png'),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () =>
                Navigator.of(context).popAndPushNamed(AuthenticationScreen.routeName),
            child: const Text('Welcome'),
          ),
        ],
      ),
    );
  }
}
