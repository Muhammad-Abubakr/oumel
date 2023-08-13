import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum NotificationType {
  orderRequest,
  orderAccepted,
  orderDenied,
  message,
}

class Notification extends Equatable {
  final NotificationType type;
  final String ref;
  final DateTime time;

  const Notification({
    required this.type,
    required this.ref,
    required this.time,
  });

  Notification copyWith({
    NotificationType? type,
    String? ref,
    DateTime? time,
  }) {
    return Notification(
      type: type ?? this.type,
      ref: ref ?? this.ref,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': describeEnum(type),
      'ref': ref,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      type: NotificationType.values.firstWhere((e) => map['type'] == describeEnum(e)),
      ref: map['ref'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, ref, time];
}
