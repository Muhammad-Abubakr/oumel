import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/widgets/client_product_widget.dart';

import '../models/product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late WaresCubit waresCubit;
  List<Product> searchedProducts = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    waresCubit = context.read<WaresCubit>();

    super.didChangeDependencies();
  }

  void searched(String searchText) {
    if (searchText.isNotEmpty) {
      searchText = searchText.toLowerCase();

      final filtered = waresCubit.state.wares
          .where((element) =>
              element.name.toLowerCase().contains(searchText) ||
              describeEnum(element.category).contains(searchText) ||
              element.location.toLowerCase().contains(searchText))
          .toList();

      setState(() {
        searchedProducts = filtered;
      });
    } else {
      setState(() {
        searchedProducts = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: searchController,
          onChanged: (searchText) => searched(searchText),
          decoration: InputDecoration(
            hintText: "Search",
            contentPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(48.r),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),

      /* body where the searched items would show */
      body: ListView.builder(
        itemBuilder: (context, index) => ClientProductWidget(searchedProducts[index]),
        itemCount: searchedProducts.length,
      ),
    );
  }
}
