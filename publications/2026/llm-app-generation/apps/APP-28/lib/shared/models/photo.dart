import 'package:uuid/uuid.dart';

class Photo {
  final String id;
  final String path;
  final String name;
  final DateTime dateCreated;
  final DateTime dateModified;
  final int size;
  final int width;
  final int height;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<String> tags;
  final bool isFavorite;
  final bool isDeleted;
  final String? albumId;
  final PhotoType type;

  Photo({
    String? id,
    required this.path,
    required this.name,
    required this.dateCreated,
    DateTime? dateModified,
    required this.size,
    required this.width,
    required this.height,
    this.location,
    this.latitude,
    this.longitude,
    List<String>? tags,
    this.isFavorite = false,
    this.isDeleted = false,
    this.albumId,
    this.type = PhotoType.image,
  }) : id = id ?? const Uuid().v4(),
       dateModified = dateModified ?? dateCreated,
       tags = tags ?? [];

  Photo copyWith({
    String? id,
    String? path,
    String? name,
    DateTime? dateCreated,
    DateTime? dateModified,
    int? size,
    int? width,
    int? height,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? tags,
    bool? isFavorite,
    bool? isDeleted,
    String? albumId,
    PhotoType? type,
  }) {
    return Photo(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
      albumId: albumId ?? this.albumId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'dateCreated': dateCreated.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
      'size': size,
      'width': width,
      'height': height,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
      'isFavorite': isFavorite,
      'isDeleted': isDeleted,
      'albumId': albumId,
      'type': type.toString(),
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      dateCreated: DateTime.parse(json['dateCreated']),
      dateModified: DateTime.parse(json['dateModified']),
      size: json['size'],
      width: json['width'],
      height: json['height'],
      location: json['location'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      albumId: json['albumId'],
      type: PhotoType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PhotoType.image,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Photo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Photo(id: $id, name: $name, path: $path)';
  }
}

enum PhotoType {
  image,
  video,
}

extension PhotoTypeExtension on PhotoType {
  String get displayName {
    switch (this) {
      case PhotoType.image:
        return 'Image';
      case PhotoType.video:
        return 'Video';
    }
  }

  bool get isImage => this == PhotoType.image;
  bool get isVideo => this == PhotoType.video;
}