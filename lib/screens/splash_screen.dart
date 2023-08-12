import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/userbase/userbase_cubit.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/screens/auth/authentication.dart';
import 'package:oumel/screens/wrapper/wrapper.dart';

import '../blocs/user/user_bloc.dart';

class SplashScreen extends StatelessWidget {
  // Route Name
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* Do the initializations (that does not concern 
    current user specifically)*/
    context.read<UserbaseCubit>().initialize();
    context.read<WaresCubit>().intialize();

    debugPrint("I am here at splash page");

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        switch (state.status) {
          case UserStates.signedIn:
          case UserStates.anonLogin:
            Future.delayed(const Duration(seconds: 3)).then((_) {
              Navigator.of(context).popAndPushNamed(Wrapper.routeName);
            });
            break;
          case UserStates.signedOut:
            Future.delayed(const Duration(seconds: 3)).then((_) {
              Navigator.of(context).popAndPushNamed(AuthenticationScreen.routeName);
            });
            break;
          default:
            break;
        }

        return Container(
          height: 1.sh,
          margin: EdgeInsets.symmetric(vertical: 20.h),
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/oumel.png'),
            ],
          ),
        );
      },
    );
  }
}
