import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/saved/saved_products_cubit.dart';
import 'package:oumel/screens/product_details_screen.dart';

import '../models/product.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.products,
    required this.index,
  });

  final List<Product> products;
  final int index;

  @override
  Widget build(BuildContext context) {
    final SavedProductsCubit savedProductsCubit = context.watch<SavedProductsCubit>();
    final savedProducts = savedProductsCubit.state.products;
    final isSaved =
        savedProducts.indexWhere((element) => element.pid == products[index].pid) > -1;
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return Card(
      elevation: 4,
      color: Colors.blueGrey.shade100,
      child: GridTile(
        header: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: isLandscape ? 160.w : 350.w,
                child: Text(
                  products[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.spMax,
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              InkWell(
                onTap: () => savedProductsCubit.toggleSavedProduct(products[index]),
                child: Icon(
                  isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                  size: 18.spMax,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
        footer: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    FontAwesomeIcons.dollarSign,
                    size: 14.spMax,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: isLandscape ? 55.w : 100.w,
                    child: Text(
                      products[index].price.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.spMax,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18.spMax,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: isLandscape ? 90.w : 180.w,
                    child: Text(
                      products[index].location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.spMax,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProductDetailsScreen(products[index]))),
          child: products[index].images != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(32.r),
                  child: Image.network(
                    products[index].images![0],
                    fit: BoxFit.cover,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 18.spMax,
                    ),
                    Text(
                      'No images to show',
                      style: TextStyle(fontSize: 12.spMax),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
