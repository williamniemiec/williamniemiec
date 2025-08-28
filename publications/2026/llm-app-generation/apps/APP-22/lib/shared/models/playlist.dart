import 'track.dart';

enum PlaylistType {
  userCreated,
  discoverWeekly,
  releaseRadar,
  dailyMix,
  likedSongs,
  madeForYou,
  collaborative,
}

class Playlist {
  final String id;
  final String name;
  final String description;
  final String coverImage;
  final String creatorId;
  final String creatorName;
  final List<Track> tracks;
  final PlaylistType type;
  final bool isPublic;
  final bool isCollaborative;
  final bool isDownloaded;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int followerCount;
  final Duration totalDuration;

  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.creatorId,
    required this.creatorName,
    required this.tracks,
    required this.type,
    this.isPublic = true,
    this.isCollaborative = false,
    this.isDownloaded = false,
    required this.createdAt,
    required this.updatedAt,
    this.followerCount = 0,
    required this.totalDuration,
  });

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImage,
    String? creatorId,
    String? creatorName,
    List<Track>? tracks,
    PlaylistType? type,
    bool? isPublic,
    bool? isCollaborative,
    bool? isDownloaded,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? followerCount,
    Duration? totalDuration,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      tracks: tracks ?? this.tracks,
      type: type ?? this.type,
      isPublic: isPublic ?? this.isPublic,
      isCollaborative: isCollaborative ?? this.isCollaborative,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followerCount: followerCount ?? this.followerCount,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  int get trackCount => tracks.length;

  bool get isEmpty => tracks.isEmpty;

  bool get isNotEmpty => tracks.isNotEmpty;

  Duration get calculatedDuration {
    return tracks.fold(
      Duration.zero,
      (total, track) => total + track.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'tracks': tracks.map((track) => track.toJson()).toList(),
      'type': type.name,
      'isPublic': isPublic,
      'isCollaborative': isCollaborative,
      'isDownloaded': isDownloaded,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'followerCount': followerCount,
      'totalDuration': totalDuration.inMilliseconds,
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      tracks: (json['tracks'] as List)
          .map((trackJson) => Track.fromJson(trackJson as Map<String, dynamic>))
          .toList(),
      type: PlaylistType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => PlaylistType.userCreated,
      ),
      isPublic: json['isPublic'] as bool? ?? true,
      isCollaborative: json['isCollaborative'] as bool? ?? false,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      followerCount: json['followerCount'] as int? ?? 0,
      totalDuration: Duration(milliseconds: json['totalDuration'] as int),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Playlist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, trackCount: $trackCount)';
  }
}