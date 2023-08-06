import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/saved/saved_products_cubit.dart';
import 'package:oumel/widgets/client_product_widget.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';

import '../../models/product.dart';

class SavedProductsScreen extends StatelessWidget {
  const SavedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedProductsCubit = context.watch<SavedProductsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: 'Saved Products'),
      ),
      body: FutureBuilder<List<Product>>(
        initialData: const [],
        future: savedProductsCubit.getSavedProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                """
An Error occured! Please try again later.
${snapshot.error}""",
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return snapshot.data!.isEmpty
                ? const Center(
                    child: Text('Nothing to show!'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8.0.r),
                    itemBuilder: (context, index) =>
                        ClientProductWidget(snapshot.data![index]),
                    itemCount: snapshot.data!.length,
                  );
          }
        },
      ),
    );
  }
}
