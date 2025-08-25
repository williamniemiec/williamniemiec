import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'podcast.g.dart';

@JsonSerializable()
class Podcast extends Equatable {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final DateTime lastUpdated;
  final String language;
  final bool isExclusive;
  final List<PodcastEpisode> episodes;
  final bool isSubscribed;
  final bool isInLibrary;

  const Podcast({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    required this.categories,
    required this.rating,
    required this.reviewCount,
    required this.lastUpdated,
    required this.language,
    required this.isExclusive,
    required this.episodes,
    this.isSubscribed = false,
    this.isInLibrary = false,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastToJson(this);

  Podcast copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    DateTime? lastUpdated,
    String? language,
    bool? isExclusive,
    List<PodcastEpisode>? episodes,
    bool? isSubscribed,
    bool? isInLibrary,
  }) {
    return Podcast(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      language: language ?? this.language,
      isExclusive: isExclusive ?? this.isExclusive,
      episodes: episodes ?? this.episodes,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isInLibrary: isInLibrary ?? this.isInLibrary,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        coverImageUrl,
        categories,
        rating,
        reviewCount,
        lastUpdated,
        language,
        isExclusive,
        episodes,
        isSubscribed,
        isInLibrary,
      ];
}

@JsonSerializable()
class PodcastEpisode extends Equatable {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final DateTime publishDate;
  final String audioUrl;
  final int episodeNumber;
  final int? seasonNumber;
  final bool isDownloaded;
  final bool isPlayed;

  const PodcastEpisode({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.publishDate,
    required this.audioUrl,
    required this.episodeNumber,
    this.seasonNumber,
    this.isDownloaded = false,
    this.isPlayed = false,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) =>
      _$PodcastEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastEpisodeToJson(this);

  PodcastEpisode copyWith({
    String? id,
    String? title,
    String? description,
    Duration? duration,
    DateTime? publishDate,
    String? audioUrl,
    int? episodeNumber,
    int? seasonNumber,
    bool? isDownloaded,
    bool? isPlayed,
  }) {
    return PodcastEpisode(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      publishDate: publishDate ?? this.publishDate,
      audioUrl: audioUrl ?? this.audioUrl,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isPlayed: isPlayed ?? this.isPlayed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        duration,
        publishDate,
        audioUrl,
        episodeNumber,
        seasonNumber,
        isDownloaded,
        isPlayed,
      ];
}