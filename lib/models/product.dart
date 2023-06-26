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
  final String name;
  final String condition;
  final String location;
  final double price;
  final ProductCategory category;
  final String description;
  final List<String>? images;
  final List<String>? videos;
  final String? color;
  final DateTime? year;

  /* Constructor */
  const Product({
    required this.name,
    required this.condition,
    required this.location,
    required this.price,
    required this.category,
    required this.description,
    this.images,
    this.videos,
    this.color,
    this.year,
  });

  @override
  List<Object?> get props {
    return [
      name,
      condition,
      location,
      price,
      category,
      description,
      images,
      videos,
      color,
      year
    ];
  }

  Product copyWith({
    String? name,
    String? condition,
    String? location,
    double? price,
    ProductCategory? category,
    String? description,
    List<String>? images,
    List<String>? videos,
    String? color,
    DateTime? year,
  }) {
    return Product(
      name: name ?? this.name,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      color: color ?? this.color,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'condition': condition,
      'location': location,
      'price': price,
      'category': describeEnum(category),
      'description': description,
      'images': images,
      'videos': videos,
      'color': color,
      'year': year?.millisecondsSinceEpoch,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      condition: map['condition'] as String,
      location: map['location'] as String,
      price: map['price'] as double,
      category: ProductCategory.values
          .firstWhere((element) => describeEnum(element.name) == map['category']),
      description: map['description'] as String,
      images:
          map['images'] != null ? List<String>.from((map['images'] as List<String>)) : null,
      videos:
          map['videos'] != null ? List<String>.from((map['videos'] as List<String>)) : null,
      color: map['color'] != null ? map['color'] as String : null,
      year:
          map['year'] != null ? DateTime.fromMillisecondsSinceEpoch(map['year'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
