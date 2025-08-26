import 'package:hive/hive.dart';

part 'episode.g.dart';

@HiveType(typeId: 1)
class Episode extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String dramaId;

  @HiveField(2)
  final int episodeNumber;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String videoUrl;

  @HiveField(6)
  final String thumbnailUrl;

  @HiveField(7)
  final int duration; // Duration in seconds

  @HiveField(8)
  final bool isFree;

  @HiveField(9)
  final int coinCost; // Cost in coins to unlock

  @HiveField(10)
  final bool isLocked;

  @HiveField(11)
  final DateTime releaseDate;

  @HiveField(12)
  final int views;

  @HiveField(13)
  final double rating;

  @HiveField(14)
  final List<String> subtitleLanguages;

  @HiveField(15)
  final Map<String, String> subtitleUrls; // Language code -> URL

  @HiveField(16)
  final String quality; // HD, FHD, 4K

  @HiveField(17)
  final bool hasNextEpisode;

  @HiveField(18)
  final bool hasPreviousEpisode;

  Episode({
    required this.id,
    required this.dramaId,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.isFree,
    required this.coinCost,
    required this.isLocked,
    required this.releaseDate,
    required this.views,
    required this.rating,
    required this.subtitleLanguages,
    required this.subtitleUrls,
    required this.quality,
    required this.hasNextEpisode,
    required this.hasPreviousEpisode,
  });

  // Factory constructor for creating Episode from JSON
  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      dramaId: json['dramaId'] as String,
      episodeNumber: json['episodeNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      duration: json['duration'] as int,
      isFree: json['isFree'] as bool,
      coinCost: json['coinCost'] as int,
      isLocked: json['isLocked'] as bool,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      views: json['views'] as int,
      rating: (json['rating'] as num).toDouble(),
      subtitleLanguages: List<String>.from(json['subtitleLanguages'] as List),
      subtitleUrls: Map<String, String>.from(json['subtitleUrls'] as Map),
      quality: json['quality'] as String,
      hasNextEpisode: json['hasNextEpisode'] as bool,
      hasPreviousEpisode: json['hasPreviousEpisode'] as bool,
    );
  }

  // Convert Episode to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dramaId': dramaId,
      'episodeNumber': episodeNumber,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'isFree': isFree,
      'coinCost': coinCost,
      'isLocked': isLocked,
      'releaseDate': releaseDate.toIso8601String(),
      'views': views,
      'rating': rating,
      'subtitleLanguages': subtitleLanguages,
      'subtitleUrls': subtitleUrls,
      'quality': quality,
      'hasNextEpisode': hasNextEpisode,
      'hasPreviousEpisode': hasPreviousEpisode,
    };
  }

  // Helper methods
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get displayTitle => 'Episode $episodeNumber: $title';

  bool get canWatch => isFree || !isLocked;

  String get accessType {
    if (isFree) return 'Free';
    if (isLocked) return 'Locked';
    return 'Premium';
  }

  // Get subtitle URL for a specific language
  String? getSubtitleUrl(String languageCode) {
    return subtitleUrls[languageCode];
  }

  // Check if subtitles are available for a language
  bool hasSubtitlesFor(String languageCode) {
    return subtitleLanguages.contains(languageCode) && 
           subtitleUrls.containsKey(languageCode);
  }

  // Copy with method for updating episode
  Episode copyWith({
    String? id,
    String? dramaId,
    int? episodeNumber,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? duration,
    bool? isFree,
    int? coinCost,
    bool? isLocked,
    DateTime? releaseDate,
    int? views,
    double? rating,
    List<String>? subtitleLanguages,
    Map<String, String>? subtitleUrls,
    String? quality,
    bool? hasNextEpisode,
    bool? hasPreviousEpisode,
  }) {
    return Episode(
      id: id ?? this.id,
      dramaId: dramaId ?? this.dramaId,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      isFree: isFree ?? this.isFree,
      coinCost: coinCost ?? this.coinCost,
      isLocked: isLocked ?? this.isLocked,
      releaseDate: releaseDate ?? this.releaseDate,
      views: views ?? this.views,
      rating: rating ?? this.rating,
      subtitleLanguages: subtitleLanguages ?? this.subtitleLanguages,
      subtitleUrls: subtitleUrls ?? this.subtitleUrls,
      quality: quality ?? this.quality,
      hasNextEpisode: hasNextEpisode ?? this.hasNextEpisode,
      hasPreviousEpisode: hasPreviousEpisode ?? this.hasPreviousEpisode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Episode && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Episode(id: $id, episodeNumber: $episodeNumber, title: $title)';
  }
}