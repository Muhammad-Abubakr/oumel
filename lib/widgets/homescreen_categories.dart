import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/models/product.dart';
import 'package:oumel/screens/products_screen.dart';

import '../screens/drawer/categories_screen.dart';

class HomescreenCategories extends StatelessWidget {
  const HomescreenCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          children: [
            TableRow(children: [
              _buildTableCell(
                context: context,
                category: ProductCategory.free,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xffffafbd), const Color(0xffffc3a0)],
                textColor: Colors.white,
              ),
              _buildTableCell(
                context: context,
                category: ProductCategory.clothing,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [const Color(0xff2193b0), const Color(0xff6dd5ed)],
                textColor: Colors.white,
              ),
            ]),
            TableRow(children: [
              _buildTableCell(
                context: context,
                category: ProductCategory.jewellery,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [const Color(0xff56ab2f), const Color(0xffa8e063)],
                textColor: Colors.white,
              ),
              _buildTableCell(
                context: context,
                category: ProductCategory.books,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [const Color(0xff4568dc), const Color(0xffb06ab3)],
                textColor: Colors.white,
              ),
            ]),
          ],
        ),
        TextButton.icon(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const CategoriesScreen())),
          icon: Icon(
            Icons.category_rounded,
            size: 18.spMax,
          ),
          label: Text(
            "See all categories",
            style: TextStyle(fontSize: 14.spMax),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        )
      ],
    );
  }

  TableCell _buildTableCell({
    required BuildContext context,
    required List<Color> colors,
    required Color textColor,
    required Alignment begin,
    required Alignment end,
    required ProductCategory category,
  }) {
    return TableCell(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsScreen(category: category),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(15.spMax),
          margin: EdgeInsets.all(5.spMax),
          alignment: Alignment.center,
          height: 1.sw / 2.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: colors,
            ),
            boxShadow: kElevationToShadow[3],
            borderRadius: BorderRadius.circular(48.r),
          ),
          child: FittedBox(
            child: Text(
              describeEnum(category)[0].toUpperCase() + describeEnum(category).substring(1),
              style: TextStyle(
                fontSize: 32.spMax,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
