import 'package:hive/hive.dart';

part 'artist.g.dart';

@HiveType(typeId: 1)
class Artist extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? bio;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final List<String> genres;

  @HiveField(5)
  final int followers;

  @HiveField(6)
  final bool isVerified;

  @HiveField(7)
  final bool isFollowed;

  @HiveField(8)
  final List<String> topSongs;

  @HiveField(9)
  final List<String> albums;

  @HiveField(10)
  final double? popularity;

  Artist({
    required this.id,
    required this.name,
    this.bio,
    this.imageUrl,
    this.genres = const [],
    this.followers = 0,
    this.isVerified = false,
    this.isFollowed = false,
    this.topSongs = const [],
    this.albums = const [],
    this.popularity,
  });

  Artist copyWith({
    String? id,
    String? name,
    String? bio,
    String? imageUrl,
    List<String>? genres,
    int? followers,
    bool? isVerified,
    bool? isFollowed,
    List<String>? topSongs,
    List<String>? albums,
    double? popularity,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      genres: genres ?? this.genres,
      followers: followers ?? this.followers,
      isVerified: isVerified ?? this.isVerified,
      isFollowed: isFollowed ?? this.isFollowed,
      topSongs: topSongs ?? this.topSongs,
      albums: albums ?? this.albums,
      popularity: popularity ?? this.popularity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'imageUrl': imageUrl,
      'genres': genres,
      'followers': followers,
      'isVerified': isVerified,
      'isFollowed': isFollowed,
      'topSongs': topSongs,
      'albums': albums,
      'popularity': popularity,
    };
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      genres: List<String>.from(json['genres'] ?? []),
      followers: json['followers'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      topSongs: List<String>.from(json['topSongs'] ?? []),
      albums: List<String>.from(json['albums'] ?? []),
      popularity: json['popularity']?.toDouble(),
    );
  }

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, followers: $followers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Artist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}