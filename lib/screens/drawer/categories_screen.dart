import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/models/product.dart';
import 'package:oumel/screens/products_screen.dart';

import '../../widgets/custom_app_bar_title.dart';

class CategoriesScreen extends StatelessWidget {
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<ProductCategory, IconData> iconMap = {
      ProductCategory.free: FontAwesomeIcons.gift,
      ProductCategory.furniture: FontAwesomeIcons.chair,
      ProductCategory.jewellery: FontAwesomeIcons.diamond,
      ProductCategory.clothing: FontAwesomeIcons.shirt,
      ProductCategory.vehicles: FontAwesomeIcons.car,
      ProductCategory.electronics: FontAwesomeIcons.mobile,
      ProductCategory.books: FontAwesomeIcons.book,
    };

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: 'Categories'),
      ),

      /* Categories */
      body: ListView.builder(
        itemBuilder: (context, index) {
          final category = ProductCategory.values[index + 1];
          final String categoryString = describeEnum(category);

          return ListTile(
            leading: FaIcon(iconMap[category]),
            title: Text(
              categoryString[0].toUpperCase() + categoryString.substring(1),
            ),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductsScreen(category: category))),
          );
        },
        itemCount: ProductCategory.values.length - 1,
      ),
    );
  }
}
