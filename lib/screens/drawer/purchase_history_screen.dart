import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/purchases/purchases_cubit.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';
import 'package:oumel/widgets/purchased_product_widget.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: "Purchases"),
      ),
      body: BlocBuilder<PurchasesCubit, PurchasesState>(
        builder: (context, state) => state.purchases.isEmpty
            ? const Center(
                child: Text("Nothing here for now."),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 36.h),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) =>
                    PurchasedProductWidget(state.purchases[index]),
                itemCount: state.purchases.length,
              ),
      ),
    );
  }
}
