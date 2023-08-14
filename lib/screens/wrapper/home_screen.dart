import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/screens/products_screen.dart';
import 'package:oumel/widgets/client_product_widget.dart';

import '../../models/product.dart';
import '../../widgets/homescreen_categories.dart';
import '../search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WaresCubit waresCubit = context.read<WaresCubit>();
    final List<Product> wares = waresCubit.state.wares;
    final limitedWares = wares.take(wares.length < 10 ? wares.length : 10).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const SearchScreen())),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search",
              contentPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.r),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ),
      ),

      //* Home Screen Body

      //* Categories Table
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 18.w, right: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomescreenCategories(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 64.h),
                  child: Text(
                    "New Arrival ✨",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProductsScreen(category: ProductCategory.none),
                    ),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    "See all",
                    style: TextStyle(fontSize: 14.spMax),
                  ),
                )
              ],
            ),
            Column(
              children: limitedWares.map((ware) => ClientProductWidget(ware)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
