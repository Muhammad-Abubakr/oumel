import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/basket/basket_cubit.dart';
import 'package:oumel/models/purchase.dart';
import 'package:oumel/widgets/cart_product_widget.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Purchase? purchase = context.watch<BasketCubit>().state.purchase;
    final products = purchase?.products;

    return purchase == null || products!.isEmpty
        ? const Center(
            child: Text("Nothing here. Go shopping 🛒"),
          )
        : ListView.separated(
            padding: EdgeInsets.all(4.spMax),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) => CartProductWidget(products[index]),
            itemCount: products.length,
          );
  }
}
