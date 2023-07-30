import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/user/user_bloc.dart';
import 'package:oumel/screens/drawer/categories_screen.dart';
import 'package:oumel/screens/drawer/saved_products_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final navigator = Navigator.of(context);

    return Drawer(
      width: !isLandscape ? 0.7.sw : 0.4.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.05.sh),
              child: Column(
                children: [
                  ListTile(
                    title:
                        const Text('Shop by category', style: TextStyle(color: Colors.white)),
                    onTap: () => navigator.pushNamed(CategoriesScreen.routeName),
                  ),
                  ListTile(
                      title: const Text('Purchases', style: TextStyle(color: Colors.white)),
                      onTap: () => {}),
                  ListTile(
                    title: const Text('Messages', style: TextStyle(color: Colors.white)),
                    onTap: () => {},
                  ),
                  ListTile(
                    title: const Text('Saved', style: TextStyle(color: Colors.white)),
                    onTap: () => navigator.push(
                        MaterialPageRoute(builder: (context) => const SavedProductsScreen())),
                  ),
                  ListTile(
                    title: const Text('About Us', style: TextStyle(color: Colors.white)),
                    onTap: () => {},
                  ),
                  ListTile(
                    title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
                    onTap: () => {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text('Log out', style: TextStyle(color: Colors.white)),
                    onTap: () => context.read<UserBloc>().add(UserSignOut()),
                  )
                ],
              ),
            ),
          ),

          /* Contact Links */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.facebook,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const FaIcon(
                  FontAwesomeIcons.youtube,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
