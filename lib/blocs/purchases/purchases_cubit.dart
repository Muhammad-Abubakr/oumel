import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:oumel/models/order.dart';
import 'package:oumel/services/firebase/auth.dart';

import '../../models/purchase.dart';

part 'purchases_state.dart';

class PurchasesCubit extends Cubit<PurchasesState> {
  final DatabaseReference _purchasesRef = FirebaseDatabase.instance.ref("purchases");
  late StreamSubscription _purchasesStream;
  late StreamSubscription _userStream;

  PurchasesCubit() : super(const PurchasesInitial([]));

  /* Initializer */
  void initialize() async {
    // subcsribe to user auth stream
    _userStream = AuthService.authStream.listen((user) {
      if (user != null) {
        // subscribe to current user's purchases stream
        _purchasesStream = _purchasesRef.child(user.uid).onValue.listen((event) {
          /* Container */
          List<Purchase> purchases = List.empty(growable: true);

          //  get the data snapshot
          final snapshot = event.snapshot;

          if (snapshot.value != null) {
            // parse the data since it is present
            final data = snapshot.value as Map<dynamic, dynamic>;

            for (var ele in data.values) {
              // cast to the Purchase Model
              final Purchase purchase = Purchase.fromJson(ele.toString());

              purchases.add(purchase);
            }
          }
          // Sort descending with time
          purchases.sort((a, b) => a.time.compareTo(b.time));
          purchases = purchases.reversed.toList();

          emit(PurchasesUpdate(purchases));
        });
      }
    });
  }

  /* Reactors (Order Accepted or Denied) */
  void orderAccepted(Purchase purchase) async {
    /* Obtaining the reference to the Purchase */
    final DatabaseReference purchaseRef =
        _purchasesRef.child("${purchase.custId}/${purchase.purRef}");

    /* Updated Purchase */
    final Purchase updated =
        purchase.copyWith(order: purchase.order.copyWith(status: OrderStatus.accepted));

    try {
      await purchaseRef.set(updated.toJson());

      /* Incase of Error */
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void orderDenied(Purchase purchase) async {
    /* Obtaining the reference to the Purchase */
    final DatabaseReference purchaseRef =
        _purchasesRef.child("${purchase.custId}/${purchase.purRef}");

    /* Updated Purchase */
    final Purchase updated =
        purchase.copyWith(order: purchase.order.copyWith(status: OrderStatus.denied));

    try {
      await purchaseRef.set(updated.toJson());

      /* Incase of Error */
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  // getting a specific purchase details
  Purchase getPurchase(String purchaseRef) {
    return state.purchases.firstWhere((element) => element.purRef == purchaseRef);
  }

  // Completed Purchases Count
  int getPurchasesCount() {
    return state.purchases
        .where((element) =>
            element.order.status == OrderStatus.accepted ||
            element.order.status == OrderStatus.completed)
        .length;
  }

  //  disposer
  void dispose() {
    /* Cancel all opened streams by this cubit */
    _userStream.cancel();
    _purchasesStream.cancel();
  }
}
