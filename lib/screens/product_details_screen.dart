import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/user/user_bloc.dart';
import '../blocs/userbase/userbase_cubit.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../screens/products_screen.dart';
import '../utils/globals.dart';
import '../widgets/custom_app_bar_title.dart';
import '../blocs/basket/basket_cubit.dart';
import '../blocs/saved/saved_products_cubit.dart';
import '../widgets/images_preview.dart';
import '../widgets/my_video_player.dart';
import 'drawer/chat_room_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(this._product, {super.key});
  final Product _product;

  @override
  Widget build(BuildContext context) {
    User productOwner = context.read<UserbaseCubit>().getUser(_product.uid);
    final currentUser = context.read<UserBloc>().state.user;
    final SavedProductsCubit savedProductsCubit = context.watch<SavedProductsCubit>();
    final BasketCubit basketCubit = context.watch<BasketCubit>();
    final savedProducts = savedProductsCubit.state.products;
    final isSaved = savedProducts.indexWhere((element) => element.pid == _product.pid) > -1;

    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarTitle(title: _product.name),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ChatRoomScreen.routeName, arguments: {
                    "currentUser": currentUser?.uid,
                    "itemOwner": productOwner,
                  }),
              icon: const Icon(Icons.chat)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 132.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* Product images Preview */
            if (_product.images == null) ...[
              SizedBox(
                height: 24.h,
              ),
              Icon(
                Icons.image_not_supported_rounded,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                size: 64.spMax,
              ),
              Text(
                "No images present for preview",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.spMax,
                ),
              ),
            ],
            if (_product.images != null) ImagesPreview(images: _product.images!),

            /* Spacing */
            SizedBox(
              height: 36.h,
            ),

            /* Videos */
            if (_product.videos != null) ...[
              SizedBox(
                height: 64.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const VerticalDivider(),
                  itemBuilder: (context, index) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                        )),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Dialog.fullscreen(
                        backgroundColor: Colors.black38,
                        child: MyVideoPlayer(null, uri: _product.videos![index]),
                      ),
                    ),
                    child: Text("Video-${index + 1}"),
                  ),
                  itemCount: _product.videos!.length,
                ),
              ),

              // Divider
              const Divider()
            ],

            /* Store information */
            ListTile(
              leading: CircleAvatar(
                  radius: 96.r, backgroundImage: Image.network(productOwner.photoURL).image),
              title: Text(
                '${productOwner.fName} ${productOwner.lName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${productOwner.phoneNumber}\n${productOwner.about}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /* Divider */
            Divider(
              height: 64.h,
            ),

            /* Product name */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.spMax),
              child: Text(
                _product.name,
                textAlign: TextAlign.left,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 20.spMax,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /* Spacing */
            SizedBox(
              height: 32.h,
            ),

            /* Product Price */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.spMax),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductsScreen(
                          category: _product.category,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.category_rounded),
                    label: Text(
                      describeEnum(_product.category)[0].toUpperCase() +
                          describeEnum(_product.category).substring(1),
                    ),
                  ),
                  Text(
                    "Price: ${cf.format(_product.price)}",
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16.spMax,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),

            /* Spacing */
            SizedBox(
              height: 64.h,
            ),

            /* Add-ons showcase */
            _buildAddOnChip(context, _product.model, prefix: "Modal(s) : "),
            _buildAddOnChip(context, _product.color, prefix: "Color(s) : "),
            _buildAddOnChip(context, _product.quantity.toString(), prefix: "Quantity : "),

            /* Separator */
            Divider(height: 128.h),

            /* Item Details */
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Text(
                "About this item",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.spMax,
                ),
              ),
            ),

            /* Spacing */
            SizedBox(
              height: 64.h,
            ),

            /* Details Table */
            Table(
              children: [
                _buildTableRow("Condition", _product.condition),
                _buildTableRow("Location", _product.location),
                _buildTableRow("Color", _product.color),
                _buildTableRow("Description", _product.description),
              ],
            ),

            /* Spacing */
            SizedBox(
              height: 128.h,
            ),

            /* Actions */
            ElevatedButton.icon(
              onPressed: () => savedProductsCubit.toggleSavedProduct(_product),
              icon: Icon(
                isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
              ),
              label: Text(isSaved ? "Saved" : "Save"),
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(0.7.sw),
              ),
            ),
            if (_product.quantity > 0)
              ElevatedButton.icon(
                onPressed: () => {},
                icon: Icon(
                  Icons.money,
                  size: 28.spMax,
                ),
                label: const Text("Buy"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(0.7.sw),
                ),
              ),
            ElevatedButton.icon(
              onPressed:
                  _product.quantity <= 0 ? null : () => basketCubit.addToBasket(_product),
              icon: Icon(
                Icons.shopping_cart,
                size: 28.spMax,
              ),
              label: Text(_product.quantity <= 0 ? "Out of stock" : "Add to Cart"),
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(0.7.sw),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 64.w),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.spMax,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 64.w),
          child: Text(
            value ?? "N/A",
            style: TextStyle(
              fontSize: 16.spMax,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOnChip(BuildContext context, String? value, {String? prefix}) {
    value = value ?? "N/A";
    String displayString = prefix != null ? prefix + value : value;

    return Container(
      width: 0.7.sw,
      padding: EdgeInsets.all(8.spMax),
      margin: EdgeInsets.symmetric(vertical: 8.spMax),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        displayString,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.spMax,
          fontFamily: 'Karma',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
