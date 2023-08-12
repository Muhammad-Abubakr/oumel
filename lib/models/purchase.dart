// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order.dart';

class Purchase extends Equatable {
  final Order order;
  final String reqRef;
  final String purRef;
  final String custId;
  final DateTime time;

  const Purchase({
    required this.order,
    required this.reqRef,
    required this.purRef,
    required this.custId,
    required this.time,
  });

  Purchase copyWith({
    Order? order,
    String? reqRef,
    String? purRef,
    String? custId,
    DateTime? time,
  }) {
    return Purchase(
      order: order ?? this.order,
      reqRef: reqRef ?? this.reqRef,
      purRef: purRef ?? this.purRef,
      custId: custId ?? this.custId,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order': order.toMap(),
      'reqRef': reqRef,
      'purRef': purRef,
      'custId': custId,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      order: Order.fromMap(map['order'] as Map<String, dynamic>),
      reqRef: map['reqRef'] as String,
      purRef: map['purRef'] as String,
      custId: map['custId'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchase.fromJson(String source) =>
      Purchase.fromMap(json.decode(source) as Map<String, dynamic>);

  String formattedTimeString() {
    String formattedString;

    formattedString =
        "Date: ${time.day}/${time.month}/${time.year}\nat ${time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute}";

    return formattedString;
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      order,
      reqRef,
      purRef,
      custId,
      time,
    ];
  }
}
