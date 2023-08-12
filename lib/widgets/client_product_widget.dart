import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/basket/basket_cubit.dart';
import 'package:oumel/screens/product_details_screen.dart';

import '../blocs/saved/saved_products_cubit.dart';
import '../models/product.dart';
import '../utils/globals.dart';

class ClientProductWidget extends StatelessWidget {
  const ClientProductWidget(this._product, {super.key});

  final Product _product;

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final SavedProductsCubit savedProductsCubit = context.watch<SavedProductsCubit>();
    final savedProducts = savedProductsCubit.state.products;
    final isSaved = savedProducts.indexWhere((element) => element.pid == _product.pid) > -1;

    return SizedBox(
      width: isLandscape ? min(820.w, 0.7.sw) : 1.0.sw,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48.r),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProductDetailsScreen(_product))),
          child: Row(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48.r),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.spMax, vertical: 10.spMax),
                  child: SizedBox(
                    height: 300.h,
                    width: 820.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //* Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(48.r),
                          child: _product.images != null
                              ? Image.network(
                                  _product.images![0],
                                  width: 300.h,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image_not_supported,
                                  size: Size.fromWidth(300.h).width),
                        ),
                        SizedBox(
                          width: 32.w,
                        ),

                        //* Product Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 480.w,
                              child: Text(
                                _product.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.spMax,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 480.w,
                              child: Text(
                                _product.description,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.spMax,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 480.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.moneyBill,
                                    size: 16.spMax,
                                    color: Theme.of(context).colorScheme.onSecondary,
                                  ),
                                  SizedBox(width: 10.spMax),
                                  Text(
                                    cf.format(_product.price),
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14.spMax,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //* Action Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => savedProductsCubit.toggleSavedProduct(_product),
                    icon: Icon(
                      isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                    ),
                  ),
                  IconButton(
                    onPressed: _product.quantity <= 0
                        ? null
                        : () => context.read<BasketCubit>().addToBasket(_product),
                    icon: const Icon(
                      FontAwesomeIcons.cartShopping,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
