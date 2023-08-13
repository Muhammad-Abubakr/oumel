import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/requests/requests_cubit.dart';

import '../blocs/purchases/purchases_cubit.dart';
import '../models/notification.dart' as notify;
import '../models/notification.dart';
import '../models/order_notification.dart';
import '../screens/drawer/order_requests_screen.dart';
import '../screens/drawer/purchase_history_screen.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notification,
  });

  final notify.Notification notification;

  @override
  Widget build(BuildContext context) {
    String leadingText = "Notification";
    String titleText = "Notification default title text";
    String trailingText = "--:--";

    /* Check which type of notification we have */
    if (notification.runtimeType == OrderNotificaiton) {
      final orderNotification = notification as OrderNotificaiton;

      /* Further Specify */
      // If notification is regarding an order request we received
      if (orderNotification.type == NotificationType.orderRequest) {
        final RequestsCubit requestsCubit = context.read<RequestsCubit>();
        final purchase = requestsCubit.getRequest(orderNotification.purchaseRef);
        trailingText = purchase.formattedTimeString();

        leadingText = "Ref#${purchase.referenceId}";
        titleText = "An order request has been received for Product#${purchase.referenceId}";

        // If the notification is regarding a purchase
      } else if (orderNotification.type == NotificationType.orderAccepted ||
          orderNotification.type == NotificationType.orderDenied) {
        final PurchasesCubit purchasesCubit = context.read<PurchasesCubit>();
        final purchase = purchasesCubit.getPurchase(orderNotification.purchaseRef);
        trailingText = purchase.formattedTimeString();

        leadingText = "Ref#${purchase.referenceId}";
        titleText =
            "Your purchase request for Product#${purchase.order.productId} has been ${notification.type == NotificationType.orderAccepted ? 'accepted' : 'rejected'} by the product owner.";
      }
    }

    return ListTile(
      // * Tap on Notification Behavior
      onTap: () {
        if (notification.type == NotificationType.orderRequest) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrderRequestsScreen()),
          );
        } else if (notification.type == NotificationType.orderAccepted ||
            notification.type == NotificationType.orderDenied) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PurchaseHistoryScreen()),
          );
        }
      },

      // * Notification Body
      title: Text(
        leadingText,
        style: TextStyle(fontSize: 12.spMax, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        titleText,
        style: TextStyle(fontSize: 12.spMax),
      ),
      trailing: Text(trailingText),
    );
  }
}
