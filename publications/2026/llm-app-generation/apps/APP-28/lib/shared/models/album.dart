import 'package:uuid/uuid.dart';
import 'photo.dart';

class Album {
  final String id;
  final String name;
  final String? description;
  final DateTime dateCreated;
  final DateTime dateModified;
  final List<String> photoIds;
  final String? coverPhotoId;
  final bool isShared;
  final List<String> sharedWith;
  final AlbumType type;
  final bool isSystemAlbum;

  Album({
    String? id,
    required this.name,
    this.description,
    DateTime? dateCreated,
    DateTime? dateModified,
    List<String>? photoIds,
    this.coverPhotoId,
    this.isShared = false,
    List<String>? sharedWith,
    this.type = AlbumType.custom,
    this.isSystemAlbum = false,
  }) : id = id ?? const Uuid().v4(),
       dateCreated = dateCreated ?? DateTime.now(),
       dateModified = dateModified ?? DateTime.now(),
       photoIds = photoIds ?? [],
       sharedWith = sharedWith ?? [];

  Album copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dateCreated,
    DateTime? dateModified,
    List<String>? photoIds,
    String? coverPhotoId,
    bool? isShared,
    List<String>? sharedWith,
    AlbumType? type,
    bool? isSystemAlbum,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      photoIds: photoIds ?? this.photoIds,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      isShared: isShared ?? this.isShared,
      sharedWith: sharedWith ?? this.sharedWith,
      type: type ?? this.type,
      isSystemAlbum: isSystemAlbum ?? this.isSystemAlbum,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dateCreated': dateCreated.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
      'photoIds': photoIds,
      'coverPhotoId': coverPhotoId,
      'isShared': isShared,
      'sharedWith': sharedWith,
      'type': type.toString(),
      'isSystemAlbum': isSystemAlbum,
    };
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dateCreated: DateTime.parse(json['dateCreated']),
      dateModified: DateTime.parse(json['dateModified']),
      photoIds: List<String>.from(json['photoIds'] ?? []),
      coverPhotoId: json['coverPhotoId'],
      isShared: json['isShared'] ?? false,
      sharedWith: List<String>.from(json['sharedWith'] ?? []),
      type: AlbumType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AlbumType.custom,
      ),
      isSystemAlbum: json['isSystemAlbum'] ?? false,
    );
  }

  int get photoCount => photoIds.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Album && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Album(id: $id, name: $name, photoCount: $photoCount)';
  }
}

enum AlbumType {
  custom,
  favorites,
  screenshots,
  camera,
  downloads,
  shared,
  archive,
  trash,
}

extension AlbumTypeExtension on AlbumType {
  String get displayName {
    switch (this) {
      case AlbumType.custom:
        return 'Custom';
      case AlbumType.favorites:
        return 'Favorites';
      case AlbumType.screenshots:
        return 'Screenshots';
      case AlbumType.camera:
        return 'Camera';
      case AlbumType.downloads:
        return 'Downloads';
      case AlbumType.shared:
        return 'Shared';
      case AlbumType.archive:
        return 'Archive';
      case AlbumType.trash:
        return 'Trash';
    }
  }

  bool get isSystemAlbum {
    switch (this) {
      case AlbumType.custom:
      case AlbumType.shared:
        return false;
      case AlbumType.favorites:
      case AlbumType.screenshots:
      case AlbumType.camera:
      case AlbumType.downloads:
      case AlbumType.archive:
      case AlbumType.trash:
        return true;
    }
  }
}

class Memory {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final List<String> photoIds;
  final String? coverPhotoId;
  final MemoryType type;

  Memory({
    String? id,
    required this.title,
    this.description,
    required this.date,
    required this.photoIds,
    this.coverPhotoId,
    this.type = MemoryType.general,
  }) : id = id ?? const Uuid().v4();

  Memory copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    List<String>? photoIds,
    String? coverPhotoId,
    MemoryType? type,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      photoIds: photoIds ?? this.photoIds,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'photoIds': photoIds,
      'coverPhotoId': coverPhotoId,
      'type': type.toString(),
    };
  }

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      photoIds: List<String>.from(json['photoIds'] ?? []),
      coverPhotoId: json['coverPhotoId'],
      type: MemoryType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MemoryType.general,
      ),
    );
  }

  int get photoCount => photoIds.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Memory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum MemoryType {
  general,
  yearAgo,
  trip,
  people,
  pets,
  celebration,
}

extension MemoryTypeExtension on MemoryType {
  String get displayName {
    switch (this) {
      case MemoryType.general:
        return 'Memory';
      case MemoryType.yearAgo:
        return 'Year Ago';
      case MemoryType.trip:
        return 'Trip';
      case MemoryType.people:
        return 'People';
      case MemoryType.pets:
        return 'Pets';
      case MemoryType.celebration:
        return 'Celebration';
    }
  }
}