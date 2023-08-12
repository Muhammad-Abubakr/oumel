import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oumel/blocs/purchases/purchases_cubit.dart';
import 'package:oumel/models/order.dart';
import 'package:oumel/models/purchase.dart';

import '../../models/product.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final DatabaseReference _requestsRef = FirebaseDatabase.instance.ref("requests");
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref("products");
  late DatabaseReference _currentUsersReqsRef;
  late StreamSubscription _currentUsersReqStream;
  late StreamSubscription _currentUserStream;
  final PurchasesCubit _purchasesCubit;

  RequestsCubit(this._purchasesCubit) : super(const RequestsInitial(requests: []));

  /* initialize */
  void initialize() {
    _currentUserStream = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _currentUsersReqsRef = _requestsRef.child(user.uid);

        /* open stream for requests for the user from the user requests reference */
        _currentUsersReqStream = _currentUsersReqsRef.onValue.listen((event) {
          // Container
          final List<Purchase> requests = List.empty(growable: true);

          final DataSnapshot snapshot = event.snapshot;

          if (snapshot.value != null) {
            final data = snapshot.value as Map<dynamic, dynamic>;

            // cast the data into a Purchase
            for (var ele in data.values) {
              final Purchase request = Purchase.fromJson(ele.toString());

              // add it to container
              requests.add(request);
            }
          }

          emit(RequestsUpdate(requests: requests));
        });
      }
    });
  }

  /* Accept and Deny Requests */
  void acceptRequest(Purchase purchase, Product product) async {
    emit(RequestsUpdate(requests: state.requests, status: RequestStatus.processing));

    // get the reference to the purchase in the requests
    final DatabaseReference purchaseRef =
        _requestsRef.child("${purchase.order.uid}/${purchase.reqRef}");

    // get the reference to the product in the database
    final DatabaseReference productRef =
        _productsRef.child("${purchase.order.uid}/${purchase.order.pid}");

    // Update the purchase object to be accepted
    Purchase updatedPurchase =
        purchase.copyWith(order: purchase.order.copyWith(status: OrderStatus.accepted));

    if (product.quantity - purchase.order.quantity < 0) {
      emit(RequestsUpdate(
          requests: state.requests,
          status: RequestStatus.error,
          error: "Order quantity cannot be satisified with the current stock."));
    } else {
      // updated product with updated quantity
      Product updatedProduct =
          product.copyWith(quantity: product.quantity - purchase.order.quantity);

      try {
        /* update the database with the updated data */
        await purchaseRef.set(updatedPurchase.toJson());
        await productRef.set(updatedProduct.toJson());

        _purchasesCubit.orderAccepted(purchase);
        emit(RequestsUpdate(requests: state.requests, status: RequestStatus.accepted));

        /* incase of any error */
      } on FirebaseException catch (e) {
        emit(RequestsUpdate(
            requests: state.requests, status: RequestStatus.error, error: e.message));
      }
    }
  }

  void denyRequest(Purchase purchase) async {
    emit(RequestsUpdate(requests: state.requests, status: RequestStatus.processing));

    // get the reference to the purchase in the requests
    final DatabaseReference purchaseRef =
        _requestsRef.child("${purchase.order.uid}/${purchase.reqRef}");

    // Update the purchase object to be accepted
    Purchase updatedPurchase =
        purchase.copyWith(order: purchase.order.copyWith(status: OrderStatus.denied));

    try {
      /* update the database with the updated data */
      await purchaseRef.set(updatedPurchase.toJson());

      _purchasesCubit.orderDenied(purchase);
      emit(RequestsUpdate(requests: state.requests, status: RequestStatus.denied));
      /* Incase of error */
    } on FirebaseException catch (e) {
      emit(RequestsUpdate(
          requests: state.requests, status: RequestStatus.error, error: e.message));
    }
  }

  /* disposition */
  void dispose() {
    // closing streams
    _currentUserStream.cancel();
    _currentUsersReqStream.cancel();

    // resetting the state
    emit(const RequestsUpdate(requests: []));
  }
}
