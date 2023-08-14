// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'products_bloc.dart';

abstract class ProductsEvent {}

/* Post Product event */
class PostProduct extends ProductsEvent {
  /* Attributes */
  final String name;
  final String condition;
  final String location;
  final double price;
  final ProductCategory category;
  final String description;
  final List<XFile>? images;
  final List<XFile>? videos;
  final int quantity;
  final String? model;
  final String? color;
  final String? year;

  PostProduct({
    required this.name,
    required this.condition,
    required this.location,
    required this.price,
    required this.category,
    required this.description,
    required this.quantity,
    this.images,
    this.videos,
    this.model,
    this.color,
    this.year,
  });
}

/* Get all products of the user */
class Initialize extends ProductsEvent {
  Initialize();
}

/* Dispose the opened streams */
class Dispose extends ProductsEvent {
  Dispose();
}

/* Private Events */
class _Update extends ProductsEvent {
  final List<Product> products;

  _Update({this.products = const []});
}
