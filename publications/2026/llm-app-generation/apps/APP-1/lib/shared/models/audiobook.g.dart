// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audiobook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audiobook _$AudiobookFromJson(Map<String, dynamic> json) => Audiobook(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      narrator: json['narrator'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      publisher: json['publisher'] as String,
      language: json['language'] as String,
      isInPlusCatalog: json['isInPlusCatalog'] as bool,
      price: (json['price'] as num).toDouble(),
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      seriesName: json['seriesName'] as String?,
      seriesNumber: (json['seriesNumber'] as num?)?.toInt(),
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      isInLibrary: json['isInLibrary'] as bool? ?? false,
      isInWishlist: json['isInWishlist'] as bool? ?? false,
    );

Map<String, dynamic> _$AudiobookToJson(Audiobook instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'narrator': instance.narrator,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'duration': instance.duration.inMicroseconds,
      'genres': instance.genres,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'publisher': instance.publisher,
      'language': instance.language,
      'isInPlusCatalog': instance.isInPlusCatalog,
      'price': instance.price,
      'chapters': instance.chapters,
      'seriesName': instance.seriesName,
      'seriesNumber': instance.seriesNumber,
      'isDownloaded': instance.isDownloaded,
      'isInLibrary': instance.isInLibrary,
      'isInWishlist': instance.isInWishlist,
    };

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
      id: json['id'] as String,
      title: json['title'] as String,
      startTime: Duration(microseconds: (json['startTime'] as num).toInt()),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      chapterNumber: (json['chapterNumber'] as num).toInt(),
    );

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startTime': instance.startTime.inMicroseconds,
      'duration': instance.duration.inMicroseconds,
      'chapterNumber': instance.chapterNumber,
    };
