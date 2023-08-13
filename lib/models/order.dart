// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum OrderStatus { completed, pending, denied, cancelled, accepted }

class Order {
  /* Attributes */
  final String uid;
  final String pid;
  final String name;
  final double price;
  final OrderStatus status;
  final int quantity;

  String get productId => pid.substring(pid.length - 4);
  String get ownerId => uid.substring(uid.length - 4);

  Order({
    required this.uid,
    required this.pid,
    required this.name,
    required this.price,
    required this.status,
    required this.quantity,
  });

  Order copyWith({
    String? uid,
    String? pid,
    String? name,
    double? price,
    OrderStatus? status,
    int? quantity,
  }) {
    return Order(
      uid: uid ?? this.uid,
      pid: pid ?? this.pid,
      name: name ?? this.name,
      price: price ?? this.price,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'pid': pid,
      'name': name,
      'price': price,
      'status': describeEnum(status),
      'quantity': quantity,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      uid: map['uid'] as String,
      pid: map['pid'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      status: OrderStatus.values.firstWhere((e) => describeEnum(e) == map['status'] as String),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(uid: $uid, pid: $pid, name: $name, price: $price, status: $status,  quantity: $quantity)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.pid == pid &&
        other.name == name &&
        other.price == price &&
        other.status == status &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        pid.hashCode ^
        name.hashCode ^
        price.hashCode ^
        status.hashCode ^
        quantity.hashCode;
  }
}
