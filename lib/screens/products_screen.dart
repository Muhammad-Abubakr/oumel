import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/products/products_bloc.dart';
import 'package:oumel/models/product.dart';

import '../widgets/product_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.category = ProductCategory.none});

  final ProductCategory category;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  /* State */
  late ProductCategory filterBy;

  @override
  void initState() {
    filterBy = widget.category;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final productsBloc = context.read<ProductsBloc>();
    final List<Product> products = productsBloc.state.products;
    final filteredProducts = products
        .where((p) => p.category == filterBy || filterBy == ProductCategory.none)
        .toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const Text(
                'Filter by : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: filterBy,
                items: ProductCategory.values
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
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text('Nothing to show!'),
            )
          : GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0.r),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLandscape ? 4 : 2),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(16.0.r),
                child: ProductWidget(products: filteredProducts, index: index),
              ),
              itemCount: filteredProducts.length,
            ),
    );
  }
}
