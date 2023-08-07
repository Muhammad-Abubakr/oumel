part of 'basket_cubit.dart';

abstract class BasketState extends Equatable {
  final Purchase? purchase;

  const BasketState(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

class BasketInitial extends BasketState {
  const BasketInitial(super.purchase);
}

class BasketUpdate extends BasketState {
  const BasketUpdate(super.purchase);
}
