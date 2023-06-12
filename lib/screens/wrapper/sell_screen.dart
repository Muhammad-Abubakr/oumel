import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/user/user_bloc.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.watch<UserBloc>();

    return userBloc.state.user!.isAnonymous
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "RESTRICTED!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  "You will need to login using an Email and Password in order to access this Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              ],
            ),
          )
        : const Placeholder();
  }
}
