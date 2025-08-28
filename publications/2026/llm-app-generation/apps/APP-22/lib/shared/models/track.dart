class Track {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String albumArt;
  final Duration duration;
  final String audioUrl;
  final bool isLiked;
  final bool isDownloaded;
  final DateTime? releaseDate;
  final List<String> genres;
  final int playCount;
  final double popularity;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArt,
    required this.duration,
    required this.audioUrl,
    this.isLiked = false,
    this.isDownloaded = false,
    this.releaseDate,
    this.genres = const [],
    this.playCount = 0,
    this.popularity = 0.0,
  });

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? albumArt,
    Duration? duration,
    String? audioUrl,
    bool? isLiked,
    bool? isDownloaded,
    DateTime? releaseDate,
    List<String>? genres,
    int? playCount,
    double? popularity,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArt: albumArt ?? this.albumArt,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
      isLiked: isLiked ?? this.isLiked,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      playCount: playCount ?? this.playCount,
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
      'duration': duration.inMilliseconds,
      'audioUrl': audioUrl,
      'isLiked': isLiked,
      'isDownloaded': isDownloaded,
      'releaseDate': releaseDate?.toIso8601String(),
      'genres': genres,
      'playCount': playCount,
      'popularity': popularity,
    };
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      albumArt: json['albumArt'] as String,
      duration: Duration(milliseconds: json['duration'] as int),
      audioUrl: json['audioUrl'] as String,
      isLiked: json['isLiked'] as bool? ?? false,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      releaseDate: json['releaseDate'] != null 
          ? DateTime.parse(json['releaseDate'] as String)
          : null,
      genres: List<String>.from(json['genres'] as List? ?? []),
      playCount: json['playCount'] as int? ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Track && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Track(id: $id, title: $title, artist: $artist)';
  }
}