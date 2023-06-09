import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthenticationScreen extends StatelessWidget {
  // Route Name
  static const routeName = '/authentication';

  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 1.sh,
        margin: EdgeInsets.symmetric(vertical: 20.h),
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/oumel.png'),
            Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                  ),
                  onPressed: () => {},
                  child: const Text('Sign in'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                  ),
                  onPressed: () => {},
                  child: const Text('Register'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size.fromWidth(0.8.sw)),
                  ),
                  onPressed: () => {},
                  child: const Text('Continue as guest'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
