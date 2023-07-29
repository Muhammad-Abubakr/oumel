part of 'products_bloc.dart';

enum ProductsStatus {
  initialized,
  processing,
  updated,
  success,
  error,
}

abstract class ProductsState extends Equatable {
  final List<Product> products;
  final ProductsStatus status;
  final String? error;

  const ProductsState({required this.products, required this.status, this.error});

  @override
  List<Object?> get props => [products, status, error];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial({required super.products, required super.status, super.error});
}

class ProductsUpdate extends ProductsState {
  const ProductsUpdate({required super.products, required super.status, super.error});
}
