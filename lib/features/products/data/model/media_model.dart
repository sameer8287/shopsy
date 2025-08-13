import 'package:pocket_fm/features/products/domain/entity/media_entity.dart';

class Media extends MediaEntity {
  final List<String>? thumbnails;
  final String? audioPreview;

  Media({
    this.thumbnails,
    this.audioPreview,
  });

  Media copyWith({
    List<String>? thumbnails,
    String? audioPreview,
  }) =>
      Media(
        thumbnails: thumbnails ?? this.thumbnails,
        audioPreview: audioPreview ?? this.audioPreview,
      );

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    thumbnails: json["thumbnails"] == null ? [] : List<String>.from(json["thumbnails"]!.map((x) => x)),
    audioPreview: json["audioPreview"],
  );

  Map<String, dynamic> toJson() => {
    "thumbnails": thumbnails == null ? [] : List<dynamic>.from(thumbnails!.map((x) => x)),
    "audioPreview": audioPreview,
  };
}