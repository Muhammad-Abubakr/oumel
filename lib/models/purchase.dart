// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order.dart';

class Purchase extends Equatable {
  final List<Order> products;
  final double totalPrice;
  final String customer;

  const Purchase({
    required this.products,
    required this.totalPrice,
    required this.customer,
  });

  Purchase copyWith({
    List<Order>? products,
    double? totalPrice,
    String? customer,
  }) {
    return Purchase(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      customer: customer ?? this.customer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'customer': customer,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      products: List<Order>.from(
        (map['products'] as List<int>).map<Order>(
          (x) => Order.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalPrice'] as double,
      customer: map['customer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchase.fromJson(String source) =>
      Purchase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [products, totalPrice, customer];
}
