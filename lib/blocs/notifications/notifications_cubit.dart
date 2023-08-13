import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:oumel/models/message_notification.dart';
import 'package:oumel/models/order_notification.dart';
import 'package:oumel/services/firebase/auth.dart';

import '../../models/notification.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final DatabaseReference _notifications = FirebaseDatabase.instance.ref("notifications");
  late DatabaseReference _messageNotificationsRef;
  late DatabaseReference _orderRequestNotificationsRef;
  late DatabaseReference _orderUpdatesNotificationsRef;
  late StreamSubscription _messageNotificationsStream;
  late StreamSubscription _orderRequestsNotificationsStream;
  late StreamSubscription _orderUpdatesNotificationsStream;
  late StreamSubscription _userStream;

  NotificationsCubit()
      : super(const NotificationsInitial(
          messageNotifications: [],
          orderRequestNotifications: [],
          orderUpdatesNotifications: [],
        ));

  /* Initializer and Disposer */
  void initialize() async {
    _userStream = AuthService.authStream.listen((user) {
      if (user != null) {
        _orderRequestNotificationsRef = _notifications.child("requests").child(user.uid);
        _orderUpdatesNotificationsRef = _notifications.child("updates").child(user.uid);
        _messageNotificationsRef = _notifications.child("messages").child(user.uid);
        // Subscribing to the notifications streams to keep our
        //  application updated at all times
        //* Order Request Stream
        _orderRequestsNotificationsStream =
            _orderRequestNotificationsRef.onValue.listen((event) {
          // Container
          List<OrderNotificaiton> container = List.empty(growable: true);

          // obtain the data snapshot from the event
          final DataSnapshot snapshot = event.snapshot;

          // check if we have data
          if (snapshot.value != null) {
            // parse it
            final data = snapshot.value as Map<dynamic, dynamic>;

            // cast it to Notifications
            for (var noti in data.values) {
              final OrderNotificaiton orderNotificaiton =
                  OrderNotificaiton.fromJson(noti.toString());

              container.add(orderNotificaiton);
            }
          }

          // Sort descending with time
          container.sort((a, b) => a.time.compareTo(b.time));
          container = container.reversed.toList();

          emit(NotificationsUpdate(
            messageNotifications: state.messageNotifications,
            orderRequestNotifications: container,
            orderUpdatesNotifications: state.orderUpdatesNotifications,
          ));
        });

        //* Order Updates Notifications Stream
        _orderUpdatesNotificationsStream =
            _orderUpdatesNotificationsRef.onValue.listen((event) {
          // Container
          List<OrderNotificaiton> container = List.empty(growable: true);

          // obtain the data snapshot from the event
          final DataSnapshot snapshot = event.snapshot;

          // check if we have data
          if (snapshot.value != null) {
            // parse it
            final data = snapshot.value as Map<dynamic, dynamic>;

            // cast it to Notifications
            for (var noti in data.values) {
              final OrderNotificaiton updateNotification =
                  OrderNotificaiton.fromJson(noti.toString());

              container.add(updateNotification);
            }
          }

          // Sort descending with time
          container.sort((a, b) => a.time.compareTo(b.time));
          container = container.reversed.toList();

          emit(NotificationsUpdate(
            messageNotifications: state.messageNotifications,
            orderRequestNotifications: state.orderRequestNotifications,
            orderUpdatesNotifications: container,
          ));
        });

        //* Message Notifications Stream
        _messageNotificationsStream = _messageNotificationsRef.onValue.listen((event) {
          // Container
          List<MessageNotification> container = List.empty(growable: true);

          // obtain the data snapshot from the event
          final DataSnapshot snapshot = event.snapshot;

          // check if we have data
          if (snapshot.value != null) {
            // parse it
            final data = snapshot.value as Map<dynamic, dynamic>;

            // cast it to Notifications
            for (var noti in data.values) {
              final MessageNotification messageNotification =
                  MessageNotification.fromJson(noti.toString());

              container.add(messageNotification);
            }
          }

          // Sort descending with time
          container.sort((a, b) => a.time.compareTo(b.time));
          container = container.reversed.toList();

          emit(NotificationsUpdate(
            messageNotifications: container,
            orderRequestNotifications: state.orderRequestNotifications,
            orderUpdatesNotifications: state.orderUpdatesNotifications,
          ));
        });
      }
    });
  }

  void dispose() async {
    /* Close the Opened Streams */
    await _messageNotificationsStream.cancel();
    await _orderUpdatesNotificationsStream.cancel();
    await _orderRequestsNotificationsStream.cancel();
    await _userStream.cancel();

    /* Reset the State */
    emit(const NotificationsUpdate(
      messageNotifications: [],
      orderRequestNotifications: [],
      orderUpdatesNotifications: [],
    ));
  }

  /* get all notifications */
  List<OrderNotificaiton> getAllNotifications() {
    final List<OrderNotificaiton> bundled =
        state.orderRequestNotifications + state.orderUpdatesNotifications;

    bundled.sort((a, b) => a.time.compareTo(b.time));

    return bundled.reversed.toList();
  }

  /* Send Notifications */
  /*   
  void notifyMessage({
      required NotificationType type,
      required String sender,
      required String receiver,
    }) {}
  */

  void notifyPurchaseRequest({
    required String ownerRef,
    required String custRef,
    required String purchaseRef,
  }) async {
    // get a reference for the new notification we are going to push
    final DatabaseReference newNotification = _orderRequestNotificationsRef.push();

    // create an OrderNotification object
    final OrderNotificaiton orderNotificaiton = OrderNotificaiton(
      type: NotificationType.orderRequest,
      ref: newNotification.key!,
      time: DateTime.now(),
      ownerRef: ownerRef,
      custRef: custRef,
      purchaseRef: purchaseRef,
    );

    /* finally push the notification to the database */
    try {
      await newNotification.set(orderNotificaiton.toJson());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void notifyPurchaseUpdate({
    required String ownerRef,
    required String custRef,
    required String purchaseRef,
    required NotificationType orderStatus,
  }) async {
    // get a reference for the new notification we are going to push
    final DatabaseReference newNotification = _orderUpdatesNotificationsRef.push();

    // create an OrderNotification object
    final OrderNotificaiton updateNotification = OrderNotificaiton(
      type: orderStatus,
      ref: newNotification.key!,
      time: DateTime.now(),
      ownerRef: ownerRef,
      custRef: custRef,
      purchaseRef: purchaseRef,
    );

    /* finally push the notification to the database */
    try {
      await newNotification.set(updateNotification.toJson());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }
}
