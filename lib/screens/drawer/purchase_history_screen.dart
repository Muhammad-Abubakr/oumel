import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/purchases/purchases_cubit.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';
import 'package:oumel/widgets/purchased_product_widget.dart';

import '../../models/order.dart';
import '../../models/purchase.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  OrderStatus filterBy = OrderStatus.pending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: "Purchases"),
        actions: [
          Row(
            children: [
              const Text(
                'Filter by : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: filterBy,
                items: OrderStatus.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            describeEnum(e),
                          ),
                        ))
                    .toList(),
                onChanged: (category) => setState(() {
                  filterBy = category ?? filterBy;
                }),
              )
            ],
          )
        ],
      ),
      body: BlocBuilder<PurchasesCubit, PurchasesState>(
        builder: (context, state) {
          /* Filter the Items based on the present filter */
          List<Purchase> filterdItems =
              state.purchases.where((p) => p.order.status == filterBy).toList();

          return state.purchases.isEmpty
              ? const Center(
                  child: Text("Nothing here for now."),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 36.h),
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => PurchasedProductWidget(filterdItems[index]),
                  itemCount: filterdItems.length,
                );
        },
      ),
    );
  }
}
