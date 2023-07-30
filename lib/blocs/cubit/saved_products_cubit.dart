import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oumel/models/product.dart';

part 'saved_products_state.dart';

class SavedProductsCubit extends Cubit<SavedProductsState> {
  // getting the reference to the database
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseReference _savedProductsRef = FirebaseDatabase.instance.ref('saved');
  late final DatabaseReference _currentUserSavedProductsRef;
  late final DatabaseReference _currentUserProductsRef;
  late StreamSubscription _savedProductsStream;

  SavedProductsCubit() : super(const SavedProductsInitial({})) {
    _currentUserSavedProductsRef = _savedProductsRef.child(_currentUser!.uid);
  }

  /* Initialize the SavedProductsCubit */
  void initialize() {
    // populate the cubit initially and keep listening to the changes made under the
    // reference
    try {
      _savedProductsStream = _currentUserSavedProductsRef.onValue.listen((event) {
        Map<String, String> savedProducts = <String, String>{};
        final DataSnapshot data = event.snapshot;

        // Check if we have any data
        if (data.value != null) {
          // parse it
          final parsed = data.value as Map<dynamic, dynamic>;

          for (var ele in parsed.entries) {
            savedProducts.addAll({ele.key: ele.value['pid']});
          }
        }

        // Once all items have been iterated
        // emit the new state
        debugPrint(savedProducts.toString());
        emit(SavedProductsUpdate(savedProducts));
      });

      // Incase of error
    } on FirebaseException catch (error) {
      debugPrint(error.message);
    }
  }

  /* Save or Unsave the product based on whether it is already saved or not */
  void toggleSavedProduct(Product product) async {
    try {
      // Check if present then remove
      if (state.products.values.contains(product.pid)) {
        // get the key
        var savedProduct =
            state.products.entries.firstWhere((element) => element.value == product.pid);

        await _currentUserSavedProductsRef.child(savedProduct.key).remove();

        // if not get a reference for the new product
      } else {
        final DatabaseReference newProductRef = _currentUserSavedProductsRef.push();

        debugPrint("Product Key: ${newProductRef.key}");
        debugPrint("Product Ref: ${newProductRef.path.split('/').last}");

        // place the new product at the obtained reference
        await newProductRef.set({'pid': product.pid});
      }

      // Incase of error
    } on FirebaseException catch (error) {
      debugPrint(error.message);
    }
  }

  /* Get List of saved products as List<Product>, where Product is our Product Modal */
  Future<List<Product>> getSavedProducts() async {
    try {
      // get all user products that map our saved products
      final List<Product> products = await Future.wait(
        state.products.values.map((productKey) async {
          // for each of the saved product get it's details
          final data = await _currentUserProductsRef.child(productKey).get();

          // parse it
          final product = Product.fromJson(data.value.toString());

          return product;
        }),
      );

      debugPrint(products.toString());
      return products;
      // Incase of error
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      return [];
    }
  }

  /* Dispose of the Opened Streams */
  void dispose() async {
    try {
      await _savedProductsStream.cancel();

      // Incase of error
    } on FirebaseException catch (error) {
      debugPrint(error.message);
    }
  }
}
