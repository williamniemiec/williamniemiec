import 'package:hive/hive.dart';
import 'episode.dart';

part 'drama.g.dart';

@HiveType(typeId: 0)
class Drama extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String synopsis;

  @HiveField(4)
  final String coverImageUrl;

  @HiveField(5)
  final String trailerUrl;

  @HiveField(6)
  final List<String> genres;

  @HiveField(7)
  final List<Episode> episodes;

  @HiveField(8)
  final int totalEpisodes;

  @HiveField(9)
  final int freeEpisodes;

  @HiveField(10)
  final double rating;

  @HiveField(11)
  final int views;

  @HiveField(12)
  final DateTime releaseDate;

  @HiveField(13)
  final DateTime updatedAt;

  @HiveField(14)
  final bool isExclusive;

  @HiveField(15)
  final bool isCompleted;

  @HiveField(16)
  final String language;

  @HiveField(17)
  final List<String> subtitleLanguages;

  @HiveField(18)
  final String director;

  @HiveField(19)
  final List<String> cast;

  @HiveField(20)
  final String studio;

  @HiveField(21)
  final int duration; // Total duration in minutes

  Drama({
    required this.id,
    required this.title,
    required this.description,
    required this.synopsis,
    required this.coverImageUrl,
    required this.trailerUrl,
    required this.genres,
    required this.episodes,
    required this.totalEpisodes,
    required this.freeEpisodes,
    required this.rating,
    required this.views,
    required this.releaseDate,
    required this.updatedAt,
    required this.isExclusive,
    required this.isCompleted,
    required this.language,
    required this.subtitleLanguages,
    required this.director,
    required this.cast,
    required this.studio,
    required this.duration,
  });

  // Factory constructor for creating Drama from JSON
  factory Drama.fromJson(Map<String, dynamic> json) {
    return Drama(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      synopsis: json['synopsis'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      trailerUrl: json['trailerUrl'] as String,
      genres: List<String>.from(json['genres'] as List),
      episodes: (json['episodes'] as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEpisodes: json['totalEpisodes'] as int,
      freeEpisodes: json['freeEpisodes'] as int,
      rating: (json['rating'] as num).toDouble(),
      views: json['views'] as int,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isExclusive: json['isExclusive'] as bool,
      isCompleted: json['isCompleted'] as bool,
      language: json['language'] as String,
      subtitleLanguages: List<String>.from(json['subtitleLanguages'] as List),
      director: json['director'] as String,
      cast: List<String>.from(json['cast'] as List),
      studio: json['studio'] as String,
      duration: json['duration'] as int,
    );
  }

  // Convert Drama to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'synopsis': synopsis,
      'coverImageUrl': coverImageUrl,
      'trailerUrl': trailerUrl,
      'genres': genres,
      'episodes': episodes.map((e) => e.toJson()).toList(),
      'totalEpisodes': totalEpisodes,
      'freeEpisodes': freeEpisodes,
      'rating': rating,
      'views': views,
      'releaseDate': releaseDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isExclusive': isExclusive,
      'isCompleted': isCompleted,
      'language': language,
      'subtitleLanguages': subtitleLanguages,
      'director': director,
      'cast': cast,
      'studio': studio,
      'duration': duration,
    };
  }

  // Helper methods
  bool get hasTrailer => trailerUrl.isNotEmpty;
  
  String get genresString => genres.join(', ');
  
  String get castString => cast.join(', ');
  
  double get averageEpisodeDuration => 
      totalEpisodes > 0 ? duration / totalEpisodes : 0.0;

  // Get episodes that are free to watch
  List<Episode> get freeEpisodesList => 
      episodes.take(freeEpisodes).toList();

  // Get episodes that require payment
  List<Episode> get paidEpisodesList => 
      episodes.skip(freeEpisodes).toList();

  // Check if a specific episode is free
  bool isEpisodeFree(int episodeNumber) => episodeNumber <= freeEpisodes;

  // Get next episode to watch based on user progress
  Episode? getNextEpisode(int lastWatchedEpisode) {
    if (lastWatchedEpisode < episodes.length) {
      return episodes[lastWatchedEpisode];
    }
    return null;
  }

  // Copy with method for updating drama
  Drama copyWith({
    String? id,
    String? title,
    String? description,
    String? synopsis,
    String? coverImageUrl,
    String? trailerUrl,
    List<String>? genres,
    List<Episode>? episodes,
    int? totalEpisodes,
    int? freeEpisodes,
    double? rating,
    int? views,
    DateTime? releaseDate,
    DateTime? updatedAt,
    bool? isExclusive,
    bool? isCompleted,
    String? language,
    List<String>? subtitleLanguages,
    String? director,
    List<String>? cast,
    String? studio,
    int? duration,
  }) {
    return Drama(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      synopsis: synopsis ?? this.synopsis,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      genres: genres ?? this.genres,
      episodes: episodes ?? this.episodes,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      freeEpisodes: freeEpisodes ?? this.freeEpisodes,
      rating: rating ?? this.rating,
      views: views ?? this.views,
      releaseDate: releaseDate ?? this.releaseDate,
      updatedAt: updatedAt ?? this.updatedAt,
      isExclusive: isExclusive ?? this.isExclusive,
      isCompleted: isCompleted ?? this.isCompleted,
      language: language ?? this.language,
      subtitleLanguages: subtitleLanguages ?? this.subtitleLanguages,
      director: director ?? this.director,
      cast: cast ?? this.cast,
      studio: studio ?? this.studio,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Drama && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Drama(id: $id, title: $title, totalEpisodes: $totalEpisodes)';
  }
}