part of 'purchases_cubit.dart';

sealed class PurchasesState extends Equatable {
  final List<Purchase> purchases;

  const PurchasesState(this.purchases);

  @override
  List<Object> get props => [purchases];
}

final class PurchasesInitial extends PurchasesState {
  const PurchasesInitial(super.purchases);
}

final class PurchasesUpdate extends PurchasesState {
  const PurchasesUpdate(super.purchases);
}
