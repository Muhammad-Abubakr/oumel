import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oumel/blocs/basket/basket_cubit.dart';
import 'package:oumel/blocs/notifications/notifications_cubit.dart';
import 'package:oumel/blocs/purchases/purchases_cubit.dart';
import 'package:oumel/blocs/requests/requests_cubit.dart';
import 'package:oumel/blocs/userchat/userchat_cubit.dart';
import 'package:oumel/screens/splash_screen.dart';
import 'package:oumel/screens/wrapper/basket_screen.dart';
import 'package:oumel/screens/wrapper/home_screen.dart';
import 'package:oumel/screens/wrapper/notifications_screen.dart';
import 'package:oumel/screens/wrapper/profile_screen.dart';
import 'package:oumel/screens/wrapper/sell_screen.dart';

import '../../blocs/products/products_bloc.dart';
import '../../blocs/saved/saved_products_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/userbase/userbase_cubit.dart';
import '../../blocs/wares/wares_cubit.dart';
import '../../widgets/main_drawer.dart';

class Wrapper extends StatefulWidget {
  // route name
  static const routeName = '/wrapper';

  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // Current Screen Index
  int currentScreen = 0;

  // Screens
  final List<Widget> screens = const <Widget>[
    HomeScreen(),
    NotificationsScreen(),
    BasketScreen(),
    SellScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    /* Initializations specific to the current User 
    should be done here */
    context.read<SavedProductsCubit>().initialize();
    context.read<UserchatCubit>().intialize();
    context.read<NotificationsCubit>().initialize();
    context.read<BasketCubit>().initialize();
    context.read<PurchasesCubit>().initialize();
    context.read<RequestsCubit>().initialize();
    context.read<ProductsBloc>().add(Initialize());

    super.initState();
  }

  @override
  void deactivate() {
    /* Disposing the Streams opened specific to user */
    context.read<SavedProductsCubit>().dispose();
    context.read<UserchatCubit>().dispose();
    context.read<BasketCubit>().dispose();
    context.read<PurchasesCubit>().dispose();
    context.read<RequestsCubit>().dispose();
    context.read<NotificationsCubit>().dispose();
    context.read<ProductsBloc>().add(Dispose());

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        switch (state.status) {
          case UserStates.updated:
            // first clear the progress indicator
            Navigator.of(context).pop();

            // and Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Updation Successful'),
              ),
            );
            break;
          case UserStates.error:
            // First Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.error?.message}'),
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

          case UserStates.signedOut:

            // clear the progress indicator
            Navigator.of(context).pop();

            // disposing streams
            context.read<UserbaseCubit>().dispose();
            context.read<WaresCubit>().dispose();

            // navigate
            Navigator.of(context)
                .pushNamedAndRemoveUntil(SplashScreen.routeName, (_) => false);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        /* Main App Bar */
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerRight,
            child: Image.asset('assets/logo2.png', fit: BoxFit.scaleDown),
          ),
        ),

        /* Main Drawer */
        drawer: const MainDrawer(),

        /* Body */
        body: screens[currentScreen],

        /* Bottom Navigation Bar */
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentScreen,
          onTap: (value) => setState(() {
            currentScreen = value;
          }),
          items: const [
            BottomNavigationBarItem(
              label: 'Market',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Notifications',
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
            ),
            BottomNavigationBarItem(
              label: 'Basket',
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: 'Sell',
              icon: Icon(Icons.sell_outlined),
              activeIcon: Icon(Icons.sell),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
