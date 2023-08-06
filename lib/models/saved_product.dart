// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SavedProduct extends Equatable {
  final String owner;
  final String pid;
  final String savedPid;
  final DateTime dateTime;

  const SavedProduct({
    required this.owner,
    required this.pid,
    required this.savedPid,
    required this.dateTime,
  });

  SavedProduct copyWith({
    String? owner,
    String? pid,
    String? savedPid,
    DateTime? dateTime,
  }) {
    return SavedProduct(
      owner: owner ?? this.owner,
      pid: pid ?? this.pid,
      savedPid: savedPid ?? this.savedPid,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'owner': owner,
      'pid': pid,
      'savedPid': savedPid,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory SavedProduct.fromMap(Map<String, dynamic> map) {
    return SavedProduct(
      owner: map['owner'] as String,
      pid: map['pid'] as String,
      savedPid: map['savedPid'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedProduct.fromJson(String source) =>
      SavedProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [owner, pid, savedPid, dateTime];
}
