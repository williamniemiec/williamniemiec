import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audiobook.g.dart';

@JsonSerializable()
class Audiobook extends Equatable {
  final String id;
  final String title;
  final String author;
  final String narrator;
  final String description;
  final String coverImageUrl;
  final Duration duration;
  final List<String> genres;
  final double rating;
  final int reviewCount;
  final DateTime releaseDate;
  final String publisher;
  final String language;
  final bool isInPlusCatalog;
  final double price;
  final List<Chapter> chapters;
  final String? seriesName;
  final int? seriesNumber;
  final bool isDownloaded;
  final bool isInLibrary;
  final bool isInWishlist;

  const Audiobook({
    required this.id,
    required this.title,
    required this.author,
    required this.narrator,
    required this.description,
    required this.coverImageUrl,
    required this.duration,
    required this.genres,
    required this.rating,
    required this.reviewCount,
    required this.releaseDate,
    required this.publisher,
    required this.language,
    required this.isInPlusCatalog,
    required this.price,
    required this.chapters,
    this.seriesName,
    this.seriesNumber,
    this.isDownloaded = false,
    this.isInLibrary = false,
    this.isInWishlist = false,
  });

  factory Audiobook.fromJson(Map<String, dynamic> json) =>
      _$AudiobookFromJson(json);

  Map<String, dynamic> toJson() => _$AudiobookToJson(this);

  Audiobook copyWith({
    String? id,
    String? title,
    String? author,
    String? narrator,
    String? description,
    String? coverImageUrl,
    Duration? duration,
    List<String>? genres,
    double? rating,
    int? reviewCount,
    DateTime? releaseDate,
    String? publisher,
    String? language,
    bool? isInPlusCatalog,
    double? price,
    List<Chapter>? chapters,
    String? seriesName,
    int? seriesNumber,
    bool? isDownloaded,
    bool? isInLibrary,
    bool? isInWishlist,
  }) {
    return Audiobook(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      narrator: narrator ?? this.narrator,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      releaseDate: releaseDate ?? this.releaseDate,
      publisher: publisher ?? this.publisher,
      language: language ?? this.language,
      isInPlusCatalog: isInPlusCatalog ?? this.isInPlusCatalog,
      price: price ?? this.price,
      chapters: chapters ?? this.chapters,
      seriesName: seriesName ?? this.seriesName,
      seriesNumber: seriesNumber ?? this.seriesNumber,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isInLibrary: isInLibrary ?? this.isInLibrary,
      isInWishlist: isInWishlist ?? this.isInWishlist,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        narrator,
        description,
        coverImageUrl,
        duration,
        genres,
        rating,
        reviewCount,
        releaseDate,
        publisher,
        language,
        isInPlusCatalog,
        price,
        chapters,
        seriesName,
        seriesNumber,
        isDownloaded,
        isInLibrary,
        isInWishlist,
      ];
}

@JsonSerializable()
class Chapter extends Equatable {
  final String id;
  final String title;
  final Duration startTime;
  final Duration duration;
  final int chapterNumber;

  const Chapter({
    required this.id,
    required this.title,
    required this.startTime,
    required this.duration,
    required this.chapterNumber,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  @override
  List<Object?> get props => [id, title, startTime, duration, chapterNumber];
}