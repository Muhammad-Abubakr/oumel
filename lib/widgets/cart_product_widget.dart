import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/basket/basket_cubit.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/models/product.dart';
import '../models/order.dart';
import '../screens/product_details_screen.dart';

class CartProductWidget extends StatelessWidget {
  const CartProductWidget(this._order, {super.key});
  final Order _order;

  @override
  Widget build(BuildContext context) {
    WaresCubit waresCubit = context.watch<WaresCubit>();
    BasketCubit basketCubit = context.watch<BasketCubit>();
    Product product = waresCubit.getProduct(_order.pid);

    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

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
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(48.r),
                          child: product.images != null
                              ? Image.network(
                                  product.images![0],
                                  width: 300.h,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image_not_supported,
                                  size: Size.fromWidth(300.h).width),
                        ),
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
                              _order.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.spMax,
                                fontWeight: FontWeight.bold,
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
                                  color: Theme.of(context).colorScheme.onSecondary,
                                ),
                                SizedBox(width: 10.spMax),
                                Text(
                                  _order.price.toStringAsFixed(2),
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
                          //*  Quantity Increase or Decrease */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /* Add Item */
                              IconButton.filledTonal(
                                onPressed: () => basketCubit.decreaseQuantity(_order.pid),
                                style: ButtonStyle(
                                  alignment: Alignment.center,
                                  padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
                                  fixedSize: MaterialStatePropertyAll(Size.fromRadius(48.r)),
                                  minimumSize: MaterialStatePropertyAll(Size.fromRadius(0.r)),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(
                                  Icons.arrow_left_rounded,
                                ),
                              ),

                              /* Spacing */
                              SizedBox(width: 64.r),

                              /* Quantity display */
                              Text(
                                "${_order.quantity}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 16.spMax,
                                ),
                              ),

                              /* Spacing */
                              SizedBox(width: 64.r),

                              /* Remove Item */
                              IconButton.filledTonal(
                                onPressed: () => basketCubit.addToBasket(product),
                                style: ButtonStyle(
                                  alignment: Alignment.center,
                                  padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
                                  fixedSize: MaterialStatePropertyAll(Size.fromRadius(48.r)),
                                  minimumSize: MaterialStatePropertyAll(Size.fromRadius(0.r)),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(
                                  Icons.arrow_right_rounded,
                                ),
                              ),
                            ],
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
                  onPressed: () => basketCubit.removeFromBasket(_order.pid),
                  icon: const Icon(
                    Icons.remove_shopping_cart_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
