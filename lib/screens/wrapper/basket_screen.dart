import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/basket/basket_cubit.dart';
import 'package:oumel/models/cart_order.dart';
import 'package:oumel/widgets/cart_product_widget.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BasketCubit basketCubit = context.watch<BasketCubit>();
    final CartOrder? purchase = basketCubit.state.purchase;
    final products = purchase?.products;

    return BlocListener<BasketCubit, BasketState>(
      listener: (context, state) {
        switch (state.status) {
          case BasketStatus.processing:
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
          case BasketStatus.error:
            // First Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${state.exception?.message}'),
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              ),
            ));
            break;
          case BasketStatus.orderPlaced:
            // pop the process indicator
            Navigator.of(context).pop();

            // First Clear the State for snackbars
            ScaffoldMessenger.of(context).clearSnackBars();

            // Then show New
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Order has been succesfully placed',
                textAlign: TextAlign.center,
              ),
            ));
            break;
          default:
            break;
        }
      },
      child: purchase == null || products!.isEmpty
          ? const Center(
              child: Text("Nothing here. Go shopping 🛒"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(4.spMax),
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => CartProductWidget(products[index]),
                    itemCount: products.length,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.spMax),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Price: ",
                        style: TextStyle(
                          fontSize: 16.spMax,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        purchase.totalPrice.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.spMax,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => basketCubit.placeOrder(),
                  icon: Icon(
                    Icons.shopping_cart_checkout_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  label: const Text("Checkout"),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
    );
  }
}
