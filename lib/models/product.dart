// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum ProductCategory {
  none,
  free,
  furniture,
  jewllery,
  clothing,
  vehicles,
  electronics,
  books,
}

class Product extends Equatable {
  /* Attributes */
  final String pid;
  final String uid;
  final String name;
  final String condition;
  final String location;
  final double price;
  final ProductCategory category;
  final String description;
  final List<String>? images;
  final List<String>? videos;
  final int quantity;
  final String? model;
  final String? color;
  final String? year;

  // Constructor
  const Product(
    this.pid, {
    required this.uid,
    required this.name,
    required this.condition,
    required this.location,
    required this.price,
    required this.category,
    required this.description,
    this.images,
    this.videos,
    required this.quantity,
    this.model,
    this.color,
    this.year,
  });

  Product copyWith({
    String? pid,
    String? uid,
    String? name,
    String? condition,
    String? location,
    double? price,
    ProductCategory? category,
    String? description,
    List<String>? images,
    List<String>? videos,
    int? quantity,
    String? model,
    String? color,
    String? year,
  }) {
    return Product(
      pid ?? this.pid,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      quantity: quantity ?? this.quantity,
      model: model ?? this.model,
      color: color ?? this.color,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'uid': uid,
      'name': name,
      'condition': condition,
      'location': location,
      'price': price,
      'category': describeEnum(category),
      'description': description,
      'images': images,
      'videos': videos,
      'quantity': quantity,
      'model': model,
      'color': color,
      'year': year,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      map['pid'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      condition: map['condition'] as String,
      location: map['location'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      description: map['description'] as String,
      category: ProductCategory.values
          .firstWhere((element) => describeEnum(element) == map['category']),
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      videos: map['videos'] != null ? List<String>.from(map['videos']) : null,
      model: map['model'] != null && (map['model'] as String).isNotEmpty
          ? map['model'] as String
          : null,
      color: map['color'] != null && (map['color'] as String).isNotEmpty
          ? map['color'] as String
          : null,
      year: map['year'] != null && (map['year'] as String).isNotEmpty
          ? map['year'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      pid,
      uid,
      name,
      condition,
      location,
      price,
      category,
      description,
      images,
      videos,
      quantity,
      model,
      color,
      year
    ];
  }

  @override
  bool get stringify => true;
}
