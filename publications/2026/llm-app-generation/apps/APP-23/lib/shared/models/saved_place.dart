import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'place.dart';

class SavedPlace {
  final String id;
  final Place place;
  final String listName;
  final DateTime savedAt;
  final String? notes;
  final bool isFavorite;

  SavedPlace({
    required this.id,
    required this.place,
    required this.listName,
    required this.savedAt,
    this.notes,
    this.isFavorite = false,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['id'] ?? '',
      place: Place.fromJson(json['place']),
      listName: json['listName'] ?? 'Favorites',
      savedAt: DateTime.parse(json['savedAt']),
      notes: json['notes'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place.toJson(),
      'listName': listName,
      'savedAt': savedAt.toIso8601String(),
      'notes': notes,
      'isFavorite': isFavorite,
    };
  }

  SavedPlace copyWith({
    String? id,
    Place? place,
    String? listName,
    DateTime? savedAt,
    String? notes,
    bool? isFavorite,
  }) {
    return SavedPlace(
      id: id ?? this.id,
      place: place ?? this.place,
      listName: listName ?? this.listName,
      savedAt: savedAt ?? this.savedAt,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedPlace && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SavedPlace(id: $id, place: ${place.name}, listName: $listName)';
  }
}

class SavedPlacesList {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final List<SavedPlace> places;
  final String iconName;
  final bool isDefault;

  SavedPlacesList({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.places = const [],
    this.iconName = 'bookmark',
    this.isDefault = false,
  });

  factory SavedPlacesList.fromJson(Map<String, dynamic> json) {
    return SavedPlacesList(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      places: (json['places'] as List?)
          ?.map((place) => SavedPlace.fromJson(place))
          .toList() ?? [],
      iconName: json['iconName'] ?? 'bookmark',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'places': places.map((place) => place.toJson()).toList(),
      'iconName': iconName,
      'isDefault': isDefault,
    };
  }

  SavedPlacesList copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    List<SavedPlace>? places,
    String? iconName,
    bool? isDefault,
  }) {
    return SavedPlacesList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      places: places ?? this.places,
      iconName: iconName ?? this.iconName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedPlacesList && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SavedPlacesList(id: $id, name: $name, places: ${places.length})';
  }
}