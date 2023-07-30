import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/models/product.dart';
import 'package:oumel/widgets/custom_app_bar_title.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(this._product, {super.key});

  final Product _product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarTitle(title: _product.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 120.r,
                backgroundImage:
                    _product.images != null ? Image.network(_product.images![0]).image : null,
                child: _product.images == null ? const Icon(Icons.image_not_supported) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
