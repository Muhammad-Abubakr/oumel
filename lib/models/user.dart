import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User extends Equatable {
  /* Attributes */
  final String fName;
  final String lName;
  final String email;
  final DateTime dob;
  final String phoneNumber;
  final String photoURL;
  final String about;
  final String uid;

  const User({
    required this.fName,
    required this.lName,
    required this.email,
    required this.dob,
    required this.phoneNumber,
    required this.photoURL,
    required this.uid,
    this.about = 'Write something here about yourself...',
  });

  User copyWith({
    String? fName,
    String? lName,
    String? email,
    DateTime? dob,
    String? phoneNumber,
    String? photoURL,
    String? about,
    String? uid,
  }) {
    return User(
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      about: about ?? this.about,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fName': fName,
      'lName': lName,
      'email': email,
      'dob': dob.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber.toString(),
      'photoURL': photoURL,
      'about': about,
      'uid': uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fName: map['fName'] as String,
      lName: map['lName'] as String,
      email: map['email'] as String,
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob'] as int),
      phoneNumber: map['phoneNumber'] as String,
      photoURL: map['photoURL'] as String,
      about: map['about'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(fName: $fName, lName: $lName, email: $email, dob: $dob, phoneNumber: $phoneNumber, photoURL: $photoURL, about: $about, uid: $uid)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.fName == fName &&
        other.lName == lName &&
        other.email == email &&
        other.dob == dob &&
        other.phoneNumber == phoneNumber &&
        other.photoURL == photoURL &&
        other.about == about &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return fName.hashCode ^
        lName.hashCode ^
        email.hashCode ^
        dob.hashCode ^
        phoneNumber.hashCode ^
        photoURL.hashCode ^
        about.hashCode ^
        uid.hashCode;
  }

  @override
  List<Object?> get props => [fName, lName, email, dob, phoneNumber, photoURL, about, uid];
}
