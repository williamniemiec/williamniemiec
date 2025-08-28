import 'package:hive/hive.dart';

part 'playlist.g.dart';

@HiveType(typeId: 2)
class Playlist extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final List<String> songIds;

  @HiveField(5)
  final String creatorId;

  @HiveField(6)
  final String creatorName;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final bool isPublic;

  @HiveField(10)
  final bool isCollaborative;

  @HiveField(11)
  final bool isOfficial;

  @HiveField(12)
  final int followers;

  @HiveField(13)
  final bool isFollowed;

  @HiveField(14)
  final bool isDownloaded;

  @HiveField(15)
  final List<String> collaborators;

  @HiveField(16)
  final String? category;

  @HiveField(17)
  final List<String> tags;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.songIds = const [],
    required this.creatorId,
    required this.creatorName,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = true,
    this.isCollaborative = false,
    this.isOfficial = false,
    this.followers = 0,
    this.isFollowed = false,
    this.isDownloaded = false,
    this.collaborators = const [],
    this.category,
    this.tags = const [],
  });

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? songIds,
    String? creatorId,
    String? creatorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    bool? isCollaborative,
    bool? isOfficial,
    int? followers,
    bool? isFollowed,
    bool? isDownloaded,
    List<String>? collaborators,
    String? category,
    List<String>? tags,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      songIds: songIds ?? this.songIds,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      isCollaborative: isCollaborative ?? this.isCollaborative,
      isOfficial: isOfficial ?? this.isOfficial,
      followers: followers ?? this.followers,
      isFollowed: isFollowed ?? this.isFollowed,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      collaborators: collaborators ?? this.collaborators,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  int get songCount => songIds.length;

  Duration get totalDuration {
    // This would be calculated based on actual songs
    // For now, return a placeholder
    return Duration(minutes: songIds.length * 3);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'songIds': songIds,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublic': isPublic,
      'isCollaborative': isCollaborative,
      'isOfficial': isOfficial,
      'followers': followers,
      'isFollowed': isFollowed,
      'isDownloaded': isDownloaded,
      'collaborators': collaborators,
      'category': category,
      'tags': tags,
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      songIds: List<String>.from(json['songIds'] ?? []),
      creatorId: json['creatorId'],
      creatorName: json['creatorName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isPublic: json['isPublic'] ?? true,
      isCollaborative: json['isCollaborative'] ?? false,
      isOfficial: json['isOfficial'] ?? false,
      followers: json['followers'] ?? 0,
      isFollowed: json['isFollowed'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
      collaborators: List<String>.from(json['collaborators'] ?? []),
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, songCount: $songCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Playlist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}