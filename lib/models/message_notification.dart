// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/* SubClass Message Notification */
import 'package:flutter/foundation.dart';

import 'notification.dart';

class MessageNotification extends Notification {
  final String receiver;
  final String sender;

  const MessageNotification({
    required this.receiver,
    required this.sender,
    required super.type,
    required super.ref,
    required super.time,
  });

  @override
  MessageNotification copyWith({
    NotificationType? type,
    String? ref,
    DateTime? time,
    String? receiver,
    String? sender,
  }) {
    return MessageNotification(
      type: type ?? super.type,
      ref: ref ?? super.ref,
      time: time ?? super.time,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': describeEnum(type),
      'ref': ref,
      'time': time.millisecondsSinceEpoch,
      'receiver': receiver,
      'sender': sender,
    };
  }

  factory MessageNotification.fromMap(Map<String, dynamic> map) {
    return MessageNotification(
      type: NotificationType.values.firstWhere((e) => map['type'] == describeEnum(e)),
      ref: map['ref'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      receiver: map['receiver'] as String,
      sender: map['sender'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory MessageNotification.fromJson(String source) =>
      MessageNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MessageNotification(time: $time ref: $ref type: ${describeEnum(type)} receiver: $receiver, sender: $sender)';

  @override
  bool operator ==(covariant MessageNotification other) {
    if (identical(this, other)) return true;

    return other.type == super.type &&
        other.ref == super.ref &&
        other.time == super.time &&
        other.receiver == receiver &&
        other.sender == sender;
  }

  @override
  int get hashCode =>
      time.hashCode ^ ref.hashCode ^ type.hashCode ^ receiver.hashCode ^ sender.hashCode;
}
