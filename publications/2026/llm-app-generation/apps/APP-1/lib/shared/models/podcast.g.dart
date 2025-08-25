// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podcast _$PodcastFromJson(Map<String, dynamic> json) => Podcast(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      language: json['language'] as String,
      isExclusive: json['isExclusive'] as bool,
      episodes: (json['episodes'] as List<dynamic>)
          .map((e) => PodcastEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      isInLibrary: json['isInLibrary'] as bool? ?? false,
    );

Map<String, dynamic> _$PodcastToJson(Podcast instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'categories': instance.categories,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'language': instance.language,
      'isExclusive': instance.isExclusive,
      'episodes': instance.episodes,
      'isSubscribed': instance.isSubscribed,
      'isInLibrary': instance.isInLibrary,
    };

PodcastEpisode _$PodcastEpisodeFromJson(Map<String, dynamic> json) =>
    PodcastEpisode(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      publishDate: DateTime.parse(json['publishDate'] as String),
      audioUrl: json['audioUrl'] as String,
      episodeNumber: (json['episodeNumber'] as num).toInt(),
      seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      isPlayed: json['isPlayed'] as bool? ?? false,
    );

Map<String, dynamic> _$PodcastEpisodeToJson(PodcastEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration.inMicroseconds,
      'publishDate': instance.publishDate.toIso8601String(),
      'audioUrl': instance.audioUrl,
      'episodeNumber': instance.episodeNumber,
      'seasonNumber': instance.seasonNumber,
      'isDownloaded': instance.isDownloaded,
      'isPlayed': instance.isPlayed,
    };
