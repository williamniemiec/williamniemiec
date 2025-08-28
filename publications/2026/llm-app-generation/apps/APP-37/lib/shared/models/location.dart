import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String? name;
  final String? placeId;

  const Location({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
    this.placeId,
  });

  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? name,
    String? placeId,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'name': name,
      'placeId': placeId,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      name: json['name'] as String?,
      placeId: json['placeId'] as String?,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, address, name, placeId];

  @override
  String toString() {
    return name ?? address ?? 'Location($latitude, $longitude)';
  }
}

class SavedLocation extends Equatable {
  final String id;
  final String label; // 'Home', 'Work', 'Custom'
  final Location location;
  final String? customName;

  const SavedLocation({
    required this.id,
    required this.label,
    required this.location,
    this.customName,
  });

  String get displayName => customName ?? label;

  SavedLocation copyWith({
    String? id,
    String? label,
    Location? location,
    String? customName,
  }) {
    return SavedLocation(
      id: id ?? this.id,
      label: label ?? this.label,
      location: location ?? this.location,
      customName: customName ?? this.customName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'location': location.toJson(),
      'customName': customName,
    };
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      id: json['id'] as String,
      label: json['label'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      customName: json['customName'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, label, location, customName];
}