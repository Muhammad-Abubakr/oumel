import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/models/product.dart';
import 'package:oumel/widgets/client_product_widget.dart';

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
    final waresCubit = context.read<WaresCubit>();
    final List<Product> wares = waresCubit.state.wares;
    final filteredWares = wares
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
      body: filteredWares.isEmpty
          ? const Center(
              child: Text('Nothing to show!'),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0.r),
              itemBuilder: (context, index) => ClientProductWidget(filteredWares[index]),
              itemCount: filteredWares.length,
            ),
    );
  }
}
