// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:pocket_fm/features/products/data/model/media_model.dart';
import 'package:pocket_fm/features/products/domain/entity/product_entity.dart';

ProductModel productFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel extends ProductEntity {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? artist;
  final String? album;
  final List<String>? genre;
  final String? language;
  final int? releaseYear;
  final int? durationSeconds;
  final double? price;
  final String? currency;
  final String? type;
  final double? rating;
  final Media? media;

  ProductModel({
    this.id,
    this.title,
    this.subtitle,
    this.description,
    this.artist,
    this.album,
    this.genre,
    this.language,
    this.releaseYear,
    this.durationSeconds,
    this.price,
    this.currency,
    this.type,
    this.rating,
    this.media,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    title: json["title"],
    subtitle: json["subtitle"],
    description: json["description"],
    artist: json["artist"],
    album: json["album"],
    genre: json["genre"] == null ? [] : List<String>.from(json["genre"]!.map((x) => x)),
    language: json["language"],
    releaseYear: json["releaseYear"],
    durationSeconds: json["durationSeconds"],
    price: json["price"]?.toDouble(),
    currency: json["currency"],
    type: json["type"],
    rating: json["rating"]?.toDouble(),
    media: json["media"] == null ? null : Media.fromJson(json["media"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "description": description,
    "artist": artist,
    "album": album,
    "genre": genre == null ? [] : List<dynamic>.from(genre!.map((x) => x)),
    "language": language,
    "releaseYear": releaseYear,
    "durationSeconds": durationSeconds,
    "price": price,
    "currency": currency,
    "type": type,
    "rating": rating,
    "media": media?.toJson(),
  };
}
