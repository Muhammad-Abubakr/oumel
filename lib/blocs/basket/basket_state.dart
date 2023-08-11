part of 'basket_cubit.dart';

enum BasketStatus { processing, error, orderPlaced }

abstract class BasketState {
  final Purchase? purchase;
  final BasketStatus? status;
  final FirebaseException? exception;

  const BasketState({this.purchase, this.status, this.exception});
}

class BasketInitial extends BasketState {
  const BasketInitial({super.purchase, super.status, super.exception});
}

class BasketUpdate extends BasketState {
  const BasketUpdate({super.purchase, super.status, super.exception});
}
