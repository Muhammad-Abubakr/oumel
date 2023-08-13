import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/basket/basket_cubit.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/models/order.dart';
import 'package:oumel/models/product.dart';
import '../models/purchase.dart';
import '../screens/product_details_screen.dart';
import '../utils/globals.dart';

class PurchasedProductWidget extends StatelessWidget {
  const PurchasedProductWidget(this._purchase, {super.key});
  final Purchase _purchase;

  @override
  Widget build(BuildContext context) {
    WaresCubit waresCubit = context.read<WaresCubit>();
    BasketCubit basketCubit = context.read<BasketCubit>();
    Product product = waresCubit.getProduct(_purchase.order.pid);

    return Container(
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.spMax, vertical: 10.spMax),
            child: SizedBox(
              height: 300.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //* Product Image
                  SizedBox(
                    width: 300.h,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48.r),
                        child: product.images != null
                            ? Image.network(
                                product.images![0],
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported,
                                size: Size.fromWidth(300.h).width),
                      ),
                    ),
                  ),

                  //* Product Details
                  SizedBox(
                    width: 380.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _purchase.order.name,
                          style: TextStyle(
                            fontSize: 14.spMax,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Text(
                          "Status: ${describeEnum(_purchase.order.status)}",
                          style: TextStyle(
                            fontSize: 14.spMax,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Text(
                          "Quantity: ${_purchase.order.quantity}",
                          style: TextStyle(
                            fontSize: 14.spMax,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyBill,
                              color: Theme.of(context).colorScheme.onSecondary,
                              size: 16.spMax,
                            ),
                            SizedBox(width: 10.spMax),
                            Text(
                              cf.format(_purchase.order.price),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14.spMax,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ref#${_purchase.referenceId}",
                        style: TextStyle(
                          fontSize: 14.spMax,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      Text(
                        _purchase.formattedTimeString(),
                        style: TextStyle(
                          fontSize: 12.spMax,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /* Bottom Action Buttons */
          Padding(
            padding: EdgeInsets.only(
              left: 8.spMax,
              right: 4.spMax,
              bottom: 4.spMax,
            ),
            child: Row(
              mainAxisAlignment: _purchase.order.status == OrderStatus.accepted
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => basketCubit.addToBasket(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ButtonTheme.of(context).colorScheme?.primary,
                    foregroundColor: ButtonTheme.of(context).colorScheme?.onPrimary,
                  ),
                  child: const Text("Buy again"),
                ),
                if (_purchase.order.status == OrderStatus.accepted)
                  ElevatedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonTheme.of(context).colorScheme?.primary,
                      foregroundColor: ButtonTheme.of(context).colorScheme?.onPrimary,
                    ),
                    child: const Text("Feedback"),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
