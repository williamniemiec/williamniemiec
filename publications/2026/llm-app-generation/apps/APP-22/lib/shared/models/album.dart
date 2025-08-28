import 'track.dart';

enum AlbumType {
  album,
  single,
  ep,
  compilation,
}

class Album {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String coverImage;
  final AlbumType type;
  final DateTime releaseDate;
  final List<Track> tracks;
  final List<String> genres;
  final String? description;
  final Duration totalDuration;
  final int totalTracks;
  final bool isLiked;
  final bool isDownloaded;
  final double popularity;

  const Album({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.coverImage,
    required this.type,
    required this.releaseDate,
    required this.tracks,
    this.genres = const [],
    this.description,
    required this.totalDuration,
    required this.totalTracks,
    this.isLiked = false,
    this.isDownloaded = false,
    this.popularity = 0.0,
  });

  Album copyWith({
    String? id,
    String? title,
    String? artistId,
    String? artistName,
    String? coverImage,
    AlbumType? type,
    DateTime? releaseDate,
    List<Track>? tracks,
    List<String>? genres,
    String? description,
    Duration? totalDuration,
    int? totalTracks,
    bool? isLiked,
    bool? isDownloaded,
    double? popularity,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      coverImage: coverImage ?? this.coverImage,
      type: type ?? this.type,
      releaseDate: releaseDate ?? this.releaseDate,
      tracks: tracks ?? this.tracks,
      genres: genres ?? this.genres,
      description: description ?? this.description,
      totalDuration: totalDuration ?? this.totalDuration,
      totalTracks: totalTracks ?? this.totalTracks,
      isLiked: isLiked ?? this.isLiked,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      popularity: popularity ?? this.popularity,
    );
  }

  Duration get calculatedDuration {
    return tracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistId': artistId,
      'artistName': artistName,
      'coverImage': coverImage,
      'type': type.name,
      'releaseDate': releaseDate.toIso8601String(),
      'tracks': tracks.map((track) => track.toJson()).toList(),
      'genres': genres,
      'description': description,
      'totalDuration': totalDuration.inMilliseconds,
      'totalTracks': totalTracks,
      'isLiked': isLiked,
      'isDownloaded': isDownloaded,
      'popularity': popularity,
    };
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      title: json['title'] as String,
      artistId: json['artistId'] as String,
      artistName: json['artistName'] as String,
      coverImage: json['coverImage'] as String,
      type: AlbumType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => AlbumType.album,
      ),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      tracks: (json['tracks'] as List)
          .map((trackJson) => Track.fromJson(trackJson as Map<String, dynamic>))
          .toList(),
      genres: List<String>.from(json['genres'] as List? ?? []),
      description: json['description'] as String?,
      totalDuration: Duration(milliseconds: json['totalDuration'] as int),
      totalTracks: json['totalTracks'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Album && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Album(id: $id, title: $title, artist: $artistName)';
  }
}