import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/screens/post_item_screen.dart';

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
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Image
                    SizedBox(
                      width: 1.sw,
                      height: 720.h,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 3,
                          sigmaY: 3,
                          tileMode: TileMode.clamp,
                        ),
                        child: Image.asset(
                          'assets/selling.jpg',
                          filterQuality: FilterQuality.none,
                        ),
                      ),
                    ),

                    /* Selling Label */
                    Text(
                      'Selling on Oumel',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: kElevationToShadow[24],
                          ),
                    ),
                  ],
                ),

                /* Instuctions */
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    /* More info button */
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                          padding: EdgeInsets.only(
                            top: 48.h,
                            left: 64.h,
                            right: 64.h,
                            bottom: 24.h,
                          )),
                      child: const Text('More infos'),
                    ),

                    /* List of Points */
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 96.h, horizontal: 0.05.sw),
                      padding: EdgeInsets.all(32.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(64.r),
                      ),
                      child: const Column(
                        children: [
                          ListPoint(
                            number: '1',
                            content: 'Get a product',
                          ),
                          ListPoint(
                            number: '2',
                            content: 'List it here on oumel',
                          ),
                          ListPoint(
                            number: '3',
                            content: 'Sell it with our protection',
                          ),
                          ListPoint(
                            number: '4',
                            content: 'Make money and earn points',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /* spacing */
                SizedBox(height: 48.h),

                /* Action to Sell Button */
                ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const PostItemScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  child: const Text('Post an item'),
                ),
              ],
            ),
          );
  }
}

class ListPoint extends StatelessWidget {
  final String number;
  final String content;

  const ListPoint({
    super.key,
    required this.content,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 48.r,
        child: Text(number),
      ),
      title: Text(
        content,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
