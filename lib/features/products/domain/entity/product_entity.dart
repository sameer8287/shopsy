import 'package:pocket_fm/features/products/domain/entity/media_entity.dart';

class ProductEntity {
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
  final MediaEntity? media;

  ProductEntity({
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

  ProductEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? artist,
    String? album,
    List<String>? genre,
    String? language,
    int? releaseYear,
    int? durationSeconds,
    double? price,
    String? currency,
    String? type,
    double? rating,
    MediaEntity? media,
  }) => ProductEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    description: description ?? this.description,
    artist: artist ?? this.artist,
    album: album ?? this.album,
    genre: genre ?? this.genre,
    language: language ?? this.language,
    releaseYear: releaseYear ?? this.releaseYear,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    type: type ?? this.type,
    rating: rating ?? this.rating,
    media: media ?? this.media,
  );
}
