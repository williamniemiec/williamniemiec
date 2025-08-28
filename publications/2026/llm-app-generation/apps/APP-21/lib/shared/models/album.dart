import 'package:hive/hive.dart';

part 'album.g.dart';

@HiveType(typeId: 4)
class Album extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artistId;

  @HiveField(3)
  final String artistName;

  @HiveField(4)
  final String? coverImageUrl;

  @HiveField(5)
  final List<String> songIds;

  @HiveField(6)
  final DateTime releaseDate;

  @HiveField(7)
  final List<String> genres;

  @HiveField(8)
  final String? description;

  @HiveField(9)
  final bool isExplicit;

  @HiveField(10)
  final bool isLiked;

  @HiveField(11)
  final bool isDownloaded;

  @HiveField(12)
  final String albumType; // album, single, EP

  @HiveField(13)
  final double? popularity;

  @HiveField(14)
  final String? label;

  Album({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    this.coverImageUrl,
    this.songIds = const [],
    required this.releaseDate,
    this.genres = const [],
    this.description,
    this.isExplicit = false,
    this.isLiked = false,
    this.isDownloaded = false,
    this.albumType = 'album',
    this.popularity,
    this.label,
  });

  Album copyWith({
    String? id,
    String? title,
    String? artistId,
    String? artistName,
    String? coverImageUrl,
    List<String>? songIds,
    DateTime? releaseDate,
    List<String>? genres,
    String? description,
    bool? isExplicit,
    bool? isLiked,
    bool? isDownloaded,
    String? albumType,
    double? popularity,
    String? label,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      songIds: songIds ?? this.songIds,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      description: description ?? this.description,
      isExplicit: isExplicit ?? this.isExplicit,
      isLiked: isLiked ?? this.isLiked,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      albumType: albumType ?? this.albumType,
      popularity: popularity ?? this.popularity,
      label: label ?? this.label,
    );
  }

  int get trackCount => songIds.length;

  Duration get totalDuration {
    // This would be calculated based on actual songs
    // For now, return a placeholder
    return Duration(minutes: songIds.length * 3);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistId': artistId,
      'artistName': artistName,
      'coverImageUrl': coverImageUrl,
      'songIds': songIds,
      'releaseDate': releaseDate.toIso8601String(),
      'genres': genres,
      'description': description,
      'isExplicit': isExplicit,
      'isLiked': isLiked,
      'isDownloaded': isDownloaded,
      'albumType': albumType,
      'popularity': popularity,
      'label': label,
    };
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      artistId: json['artistId'],
      artistName: json['artistName'],
      coverImageUrl: json['coverImageUrl'],
      songIds: List<String>.from(json['songIds'] ?? []),
      releaseDate: DateTime.parse(json['releaseDate']),
      genres: List<String>.from(json['genres'] ?? []),
      description: json['description'],
      isExplicit: json['isExplicit'] ?? false,
      isLiked: json['isLiked'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
      albumType: json['albumType'] ?? 'album',
      popularity: json['popularity']?.toDouble(),
      label: json['label'],
    );
  }

  @override
  String toString() {
    return 'Album(id: $id, title: $title, artist: $artistName, trackCount: $trackCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Album && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}