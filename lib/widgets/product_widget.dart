import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/cubit/saved_products_cubit.dart';

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

    return Card(
      elevation: 4,
      child: GridTile(
        header: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 16.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Text(
            products[index].name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        footer: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
          ),
          child: FittedBox(
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => savedProductsCubit.toggleSavedProduct(products[index]),
                  icon: Icon(savedProducts.values.contains(products[index].pid)
                      ? FontAwesomeIcons.solidBookmark
                      : FontAwesomeIcons.bookmark),
                  label: const Text('Save'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.cartShopping),
                  label: const Text('Add to cart'),
                ),
              ],
            ),
          ),
        ),
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
    );
  }
}
