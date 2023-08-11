import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oumel/models/order.dart';
import 'package:oumel/models/purchase.dart';

import '../../models/product.dart';

part 'basket_state.dart';

class BasketCubit extends Cubit<BasketState> {
  late StreamSubscription _userStream;
  User? _currentUser;

  BasketCubit() : super(const BasketInitial());

  /* Cubit initialization */
  void initialize() {
    // initialize user stream
    _userStream = FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
  }

  /* Dispose */
  void dispose() {
    // cancel streams
    _userStream.cancel();
    // reset state
    emit(const BasketUpdate());
  }

  /* Calculates new total for the given list of products */
  double getTotal(List<Order> products) {
    double total = 0;

    for (var order in products) {
      total += order.price * order.quantity;
    }

    return total;
  }

  /* Adds te given product to the basket 
  if already present, increase the quantity
   */
  void addToBasket(Product product) {
    /* Initializing the new order object */
    Order order = Order(
      uid: product.uid,
      pid: product.pid,
      name: product.name,
      price: product.price,
      status: OrderStatus.pending,
      quantity: 1,
    );

    /* Initial Check: Purchase is null. that means this is the first item */
    if (state.purchase == null) {
      List<Order> orders = [order];

      Purchase newPurchase = Purchase(
        products: orders,
        totalPrice: getTotal(orders),
        customer: _currentUser!.uid,
      );

      // emit the new purchase
      emit(BasketUpdate(
        purchase: newPurchase,
      ));

      /* If we reach here that means that purchase was already initialized */
    } else {
      /* Check if the product is already in the basket */
      int idx = state.purchase!.products.indexWhere((element) => element.pid == product.pid);
      List<Order> updatedOrders = List.empty();

      // this means the product is present
      if (idx > -1) {
        Order order = state.purchase!.products[idx];

        Order updatedOrder = order.copyWith(quantity: order.quantity + 1);

        state.purchase!.products.replaceRange(idx, idx + 1, [updatedOrder]);

        updatedOrders = [...state.purchase!.products];

        // if not already present in the products
      } else {
        updatedOrders = [
          ...state.purchase!.products,
          order,
        ];
      }

      double updatedTotal = getTotal(updatedOrders);

      Purchase updatedPurchase = state.purchase!.copyWith(
        products: updatedOrders,
        totalPrice: updatedTotal,
      );

      emit(BasketUpdate(
        purchase: updatedPurchase,
      ));
    }
  }

  /* Remove from basket (literally) */
  void removeFromBasket(String pid) {
    state.purchase!.products.removeWhere((o) => o.pid == pid);

    if (state.purchase!.products.isEmpty) {
      emit(const BasketUpdate(
        purchase: null,
      ));
    } else {
      Purchase updatedState = state.purchase!.copyWith(
        products: [...state.purchase!.products],
        totalPrice: getTotal(state.purchase!.products),
      );
      emit(BasketUpdate(
        purchase: updatedState,
      ));
    }
  }

  void decreaseQuantity(String pid) {
    /* Reduce the quantity of the product will need to see if
     the quantity of the product is 1. Directly remove the 
     product from the basket
    */
    int orderIdx = state.purchase!.products.indexWhere((element) => element.pid == pid);
    Order order = state.purchase!.products[orderIdx];

    if (order.quantity == 1) {
      removeFromBasket(pid);
    } else {
      // decrease quantity by 1
      Order updatedOrder = order.copyWith(quantity: order.quantity - 1);

      state.purchase!.products.replaceRange(orderIdx, orderIdx + 1, [updatedOrder]);

      Purchase updatedState = state.purchase!.copyWith(
        products: [...state.purchase!.products],
        totalPrice: getTotal(state.purchase!.products),
      );

      emit(BasketUpdate(
        purchase: updatedState,
      ));
    }
  }

  void placeOrder() async {
    emit(BasketUpdate(
      status: BasketStatus.processing,
      purchase: state.purchase,
    ));

    try {
      if (state.purchase != null) {
        for (var product in state.purchase!.products) {
          final requestsRef = FirebaseDatabase.instance.ref("requests");
          var ownersRef = requestsRef.child(product.uid);
          var customerRef = ownersRef.child(_currentUser!.uid);

          final newRequestRef = customerRef.push();
          await newRequestRef.set({
            "product": product.toJson(),
            "time": DateTime.now().millisecondsSinceEpoch,
            "req_ref": newRequestRef.key,
          });

          final purchasesRef = FirebaseDatabase.instance.ref("purchases");
          customerRef = purchasesRef.child(_currentUser!.uid);
          ownersRef = customerRef.child(product.uid);

          final newPurchaseRef = ownersRef.push();
          await newPurchaseRef.set({
            "product": product.toJson(),
            "time": DateTime.now().millisecondsSinceEpoch,
            "pur_ref": newPurchaseRef.key,
          });
        }

        emit(const BasketUpdate(
          status: BasketStatus.orderPlaced,
          purchase: null,
        ));
      }
    } on FirebaseException catch (e) {
      emit(BasketUpdate(
        status: BasketStatus.error,
        exception: e,
        purchase: state.purchase,
      ));
    }
  }
}
