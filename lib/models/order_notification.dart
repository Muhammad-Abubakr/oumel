/* SubClass Order Notification */
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'notification.dart';

class OrderNotificaiton extends Notification {
  final String ownerRef;
  final String custRef;
  final String purchaseRef;

  const OrderNotificaiton({
    required super.type,
    required super.ref,
    required super.time,
    required this.ownerRef,
    required this.custRef,
    required this.purchaseRef,
  });

  @override
  OrderNotificaiton copyWith({
    NotificationType? type,
    String? ref,
    DateTime? time,
    String? ownerRef,
    String? custRef,
    String? purchaseRef,
  }) {
    return OrderNotificaiton(
      type: type ?? super.type,
      ref: ref ?? super.ref,
      time: time ?? super.time,
      ownerRef: ownerRef ?? this.ownerRef,
      custRef: custRef ?? this.custRef,
      purchaseRef: purchaseRef ?? this.purchaseRef,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': describeEnum(type),
      'ref': ref,
      'time': time.millisecondsSinceEpoch,
      'ownerRef': ownerRef,
      'custRef': custRef,
      'purchaseRef': purchaseRef,
    };
  }

  factory OrderNotificaiton.fromMap(Map<String, dynamic> map) {
    return OrderNotificaiton(
      type: NotificationType.values.firstWhere((e) => map['type'] == describeEnum(e)),
      ref: map['ref'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      ownerRef: map['ownerRef'] as String,
      custRef: map['custRef'] as String,
      purchaseRef: map['purchaseRef'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory OrderNotificaiton.fromJson(String source) =>
      OrderNotificaiton.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderNotificaiton(time: $time ref: $ref type: ${describeEnum(type)} ownerRef: $ownerRef, custRef: $custRef, purchaseRef: $purchaseRef)';

  @override
  bool operator ==(covariant OrderNotificaiton other) {
    if (identical(this, other)) return true;

    return other.type == super.type &&
        other.ref == super.ref &&
        other.time == super.time &&
        other.ownerRef == ownerRef &&
        other.custRef == custRef &&
        other.purchaseRef == purchaseRef;
  }

  @override
  int get hashCode =>
      time.hashCode ^
      ref.hashCode ^
      type.hashCode ^
      ownerRef.hashCode ^
      custRef.hashCode ^
      purchaseRef.hashCode;
}
