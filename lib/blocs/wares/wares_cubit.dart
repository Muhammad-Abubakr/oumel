import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../models/product.dart';

part 'wares_state.dart';

class WaresCubit extends Cubit<WaresState> {
  /* Firebase Database instance */
  final _productsRef = FirebaseDatabase.instance.ref("products");

  /* Streams Array */
  late StreamSubscription _productsStream;

  /* Constructor */
  WaresCubit() : super(const WaresInitial(wares: []));

  // Initialize wares
  Future<void> intialize() async {
    // setting up a stream to firebase database ref items
    _productsStream = _productsRef.onValue.listen((event) {
      /* Container for wares */
      final List<Product> wares = List.empty(growable: true);

      // Getting the data from firebase
      var data = event.snapshot.value as Map<dynamic, dynamic>?;

      // if we have some data
      if (data != null) {
        // filter the current user items
        for (var element in data.entries) {
          // if (element.key != FirebaseAuth.instance.currentUser?.uid) {
          // Now we will get the data items for each user except the logged in
          final products = element.value as Map<dynamic, dynamic>;

          // iterating on each item and parsing it as Item
          for (var product in products.values) {
            final parsedProduct = Product.fromJson(product.toString());

            // collecting the parsed item
            wares.add(parsedProduct);
          }
          // }
        }
      }

      /* and once we have iterated on all the users for all items they have */
      emit(WaresUpdated(wares: wares));
    });
  }

  /* Cancel Streams */
  void dispose() async {
    await _productsStream.cancel();

    /* and clear state */
    emit(const WaresUpdated(wares: []));

    if (kDebugMode) {
      print("Ware Streams have been cancelled!");
    }
  }
}
