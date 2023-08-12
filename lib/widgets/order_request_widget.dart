import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oumel/blocs/requests/requests_cubit.dart';
import 'package:oumel/blocs/userbase/userbase_cubit.dart';
import 'package:oumel/blocs/wares/wares_cubit.dart';
import 'package:oumel/models/order.dart';
import 'package:oumel/models/product.dart';
import 'package:oumel/models/user.dart';
import '../models/purchase.dart';
import '../screens/drawer/chat_room_screen.dart';
import '../screens/product_details_screen.dart';
import '../utils/globals.dart';

class OrderRequestWidget extends StatelessWidget {
  const OrderRequestWidget(this._purchase, {super.key});
  final Purchase _purchase;

  @override
  Widget build(BuildContext context) {
    UserbaseCubit userbase = context.read<UserbaseCubit>();
    WaresCubit waresCubit = context.read<WaresCubit>();
    RequestsCubit requestsCubit = context.read<RequestsCubit>();
    Product product = waresCubit.getProduct(_purchase.order.pid);
    User customer = userbase.getUser(_purchase.custId);
    User currentUser = userbase.getUser(product.uid);

    return Card(
      elevation: 4,
      child: Column(
        children: [
          /* Customer Information */
          ListTile(
            textColor: Theme.of(context).colorScheme.secondary,
            iconColor: Theme.of(context).colorScheme.onPrimary,
            leading: CircleAvatar(
                radius: 96.r, backgroundImage: Image.network(customer.photoURL).image),
            title: Text(
              '${customer.fName} ${customer.lName}',
              style: TextStyle(
                fontSize: 14.spMax,
              ),
            ),
            subtitle: Text(
              customer.phoneNumber,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton.filled(
              onPressed: () {
                Navigator.of(context).pushNamed(ChatRoomScreen.routeName, arguments: {
                  "currentUser": currentUser.uid,
                  "itemOwner": customer,
                });
              },
              icon: const Icon(Icons.message),
            ),
          ),

          /* Divider */
          const Divider(),

          /* Product Info */
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.spMax, vertical: 10.spMax),
            child: SizedBox(
              height: 300.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //* Product Image
                  SizedBox(
                    width: 300.h,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48.r),
                        child: product.images != null
                            ? Image.network(
                                product.images![0],
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported,
                                size: Size.fromWidth(300.h).width),
                      ),
                    ),
                  ),

                  //* Product Details
                  SizedBox(
                    width: 380.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _purchase.order.name,
                          style: TextStyle(
                            fontSize: 14.spMax,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          "Status: ${describeEnum(_purchase.order.status)}",
                          style: TextStyle(
                            fontSize: 14.spMax,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          "Quantity: ${_purchase.order.quantity}",
                          style: TextStyle(
                            fontSize: 14.spMax,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyBill,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16.spMax,
                            ),
                            SizedBox(width: 10.spMax),
                            Text(
                              cf.format(_purchase.order.price),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14.spMax,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _purchase.formattedTimeString(),
                      style: TextStyle(
                        fontSize: 12.spMax,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* Bottom Action Buttons */
          if (_purchase.order.status == OrderStatus.pending)
            Padding(
              padding: EdgeInsets.only(
                left: 4.spMax,
                right: 4.spMax,
                bottom: 4.spMax,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => requestsCubit.acceptRequest(_purchase, product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonTheme.of(context).colorScheme?.primary,
                      foregroundColor: ButtonTheme.of(context).colorScheme?.onPrimary,
                    ),
                    child: const Text("Accept"),
                  ),
                  ElevatedButton(
                    onPressed: () => requestsCubit.denyRequest(_purchase),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonTheme.of(context).colorScheme?.primary,
                      foregroundColor: ButtonTheme.of(context).colorScheme?.onPrimary,
                    ),
                    child: const Text("Deny"),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
