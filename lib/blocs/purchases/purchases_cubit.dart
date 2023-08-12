import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
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
          final List<Purchase> purchases = List.empty(growable: true);

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

          emit(PurchasesUpdate(purchases));
        });
      }
    });
  }

  //  disposer
  void dispose() {
    /* Cancel all opened streams by this cubit */
    _userStream.cancel();
    _purchasesStream.cancel();
  }
}
