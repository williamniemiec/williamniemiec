import 'package:hive/hive.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String album;

  @HiveField(4)
  final String? albumArt;

  @HiveField(5)
  final String? videoUrl;

  @HiveField(6)
  final String? audioUrl;

  @HiveField(7)
  final Duration duration;

  @HiveField(8)
  final List<String> genres;

  @HiveField(9)
  final DateTime releaseDate;

  @HiveField(10)
  final bool isExplicit;

  @HiveField(11)
  final bool isDownloaded;

  @HiveField(12)
  final bool isPremiumOnly;

  @HiveField(13)
  final String? lyrics;

  @HiveField(14)
  final int playCount;

  @HiveField(15)
  final bool isLiked;

  @HiveField(16)
  final String? artistId;

  @HiveField(17)
  final String? albumId;

  @HiveField(18)
  final double? popularity;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    this.albumArt,
    this.videoUrl,
    this.audioUrl,
    required this.duration,
    this.genres = const [],
    required this.releaseDate,
    this.isExplicit = false,
    this.isDownloaded = false,
    this.isPremiumOnly = false,
    this.lyrics,
    this.playCount = 0,
    this.isLiked = false,
    this.artistId,
    this.albumId,
    this.popularity,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? albumArt,
    String? videoUrl,
    String? audioUrl,
    Duration? duration,
    List<String>? genres,
    DateTime? releaseDate,
    bool? isExplicit,
    bool? isDownloaded,
    bool? isPremiumOnly,
    String? lyrics,
    int? playCount,
    bool? isLiked,
    String? artistId,
    String? albumId,
    double? popularity,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArt: albumArt ?? this.albumArt,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      releaseDate: releaseDate ?? this.releaseDate,
      isExplicit: isExplicit ?? this.isExplicit,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isPremiumOnly: isPremiumOnly ?? this.isPremiumOnly,
      lyrics: lyrics ?? this.lyrics,
      playCount: playCount ?? this.playCount,
      isLiked: isLiked ?? this.isLiked,
      artistId: artistId ?? this.artistId,
      albumId: albumId ?? this.albumId,
      popularity: popularity ?? this.popularity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArt': albumArt,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'duration': duration.inMilliseconds,
      'genres': genres,
      'releaseDate': releaseDate.toIso8601String(),
      'isExplicit': isExplicit,
      'isDownloaded': isDownloaded,
      'isPremiumOnly': isPremiumOnly,
      'lyrics': lyrics,
      'playCount': playCount,
      'isLiked': isLiked,
      'artistId': artistId,
      'albumId': albumId,
      'popularity': popularity,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      albumArt: json['albumArt'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      duration: Duration(milliseconds: json['duration']),
      genres: List<String>.from(json['genres'] ?? []),
      releaseDate: DateTime.parse(json['releaseDate']),
      isExplicit: json['isExplicit'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
      isPremiumOnly: json['isPremiumOnly'] ?? false,
      lyrics: json['lyrics'],
      playCount: json['playCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      artistId: json['artistId'],
      albumId: json['albumId'],
      popularity: json['popularity']?.toDouble(),
    );
  }

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}