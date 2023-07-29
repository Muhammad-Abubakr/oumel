part of 'saved_products_cubit.dart';

abstract class SavedProductsState {
  final Map<String, String> products;

  const SavedProductsState(this.products);
}

class SavedProductsInitial extends SavedProductsState {
  const SavedProductsInitial(super.products);
}

class SavedProductsUpdate extends SavedProductsState {
  const SavedProductsUpdate(super.products);
}
