import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oumel/models/product.dart';

import '../../models/saved_product.dart';

part 'saved_products_state.dart';

class SavedProductsCubit extends Cubit<SavedProductsState> {
  // getting the reference to the database
  late StreamSubscription<User?> _userStream;
  final DatabaseReference _savedProductsRef = FirebaseDatabase.instance.ref('saved');
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref('products');
  late DatabaseReference _currentUserSavedProductsRef;
  late StreamSubscription _savedProductsStream;

  SavedProductsCubit() : super(const SavedProductsInitial([]));
  /* Initialize the SavedProductsCubit */
  void initialize() {
    // populate the cubit initially and keep listening to the changes made under the
    // reference
    try {
      _userStream = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          /* Update Saved products ref for the latest user */
          _currentUserSavedProductsRef = _savedProductsRef.child(user.uid);

          /* Start listening to User's saved products stream */
          _savedProductsStream = _currentUserSavedProductsRef.onValue.listen((event) {
            /* Container */
            final List<SavedProduct> savedProducts = [];
            final DataSnapshot data = event.snapshot;

            // Check if we have any data
            if (data.value != null) {
              // parse it
              final parsed = data.value as Map<dynamic, dynamic>;

              for (var saved in parsed.values) {
                // parse it as a SavedProduct
                final SavedProduct savedProduct = SavedProduct.fromJson(saved.toString());

                // add it to the container
                savedProducts.add(savedProduct);
              }
            }
            // Once all items have been iterated
            // emit the new state
            emit(SavedProductsUpdate(savedProducts));
          });
        }
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
      if (state.products.indexWhere((element) => element.pid == product.pid) > -1) {
        // get the key
        SavedProduct savedProduct =
            state.products.firstWhere((element) => element.pid == product.pid);

        await _currentUserSavedProductsRef.child(savedProduct.savedPid).remove();

        // if not get a reference for the new product
      } else {
        final DatabaseReference newProductRef = _currentUserSavedProductsRef.push();

        // create the new saved product
        SavedProduct savingNewProduct = SavedProduct(
            owner: product.uid,
            pid: product.pid,
            savedPid: "${newProductRef.key}",
            dateTime: DateTime.now());

        // place the new product at the obtained reference
        await newProductRef.set(savingNewProduct.toJson());
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
        state.products.map((saved) async {
          // for each of the saved product get it's details
          final productRef = _productsRef.child("${saved.owner}/${saved.pid}");
          final data = await productRef.get();

          // cast it to product
          final product = Product.fromJson(data.value.toString());

          return product;
        }),
      );

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
      await _userStream.cancel();
      emit(const SavedProductsUpdate([]));

      // Incase of error
    } on FirebaseException catch (error) {
      debugPrint(error.message);
    }
  }
}
