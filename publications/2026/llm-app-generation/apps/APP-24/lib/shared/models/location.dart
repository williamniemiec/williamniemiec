import 'dart:math' as math;
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? bearing; // Direction in degrees (0-360)
  final double? speed; // Speed in m/s
  final DateTime? timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.bearing,
    this.speed,
    this.timestamp,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      bearing: (json['bearing'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'bearing': bearing,
      'speed': speed,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    double? bearing,
    double? speed,
    DateTime? timestamp,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      bearing: bearing ?? this.bearing,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Calculate distance between two locations in meters
  double distanceTo(Location other) {
    const double earthRadius = 6371000; // Earth's radius in meters
    
    final double lat1Rad = latitude * (3.14159265359 / 180);
    final double lat2Rad = other.latitude * (3.14159265359 / 180);
    final double deltaLatRad = (other.latitude - latitude) * (3.14159265359 / 180);
    final double deltaLngRad = (other.longitude - longitude) * (3.14159265359 / 180);

    final double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  // Calculate bearing to another location in degrees
  double bearingTo(Location other) {
    final double lat1Rad = latitude * (3.14159265359 / 180);
    final double lat2Rad = other.latitude * (3.14159265359 / 180);
    final double deltaLngRad = (other.longitude - longitude) * (3.14159265359 / 180);

    final double y = math.sin(deltaLngRad) * math.cos(lat2Rad);
    final double x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(deltaLngRad);

    final double bearingRad = math.atan2(y, x);
    final double bearingDeg = bearingRad * (180 / 3.14159265359);

    return (bearingDeg + 360) % 360;
  }

  // Check if this location is within a certain radius of another location
  bool isWithinRadius(Location other, double radiusInMeters) {
    return distanceTo(other) <= radiusInMeters;
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        altitude,
        accuracy,
        bearing,
        speed,
        timestamp,
      ];

  @override
  String toString() {
    return 'Location(lat: $latitude, lng: $longitude, accuracy: $accuracy)';
  }
}

class LocationBounds extends Equatable {
  final Location southwest;
  final Location northeast;

  const LocationBounds({
    required this.southwest,
    required this.northeast,
  });

  factory LocationBounds.fromJson(Map<String, dynamic> json) {
    return LocationBounds(
      southwest: Location.fromJson(json['southwest'] as Map<String, dynamic>),
      northeast: Location.fromJson(json['northeast'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'southwest': southwest.toJson(),
      'northeast': northeast.toJson(),
    };
  }

  // Check if a location is within these bounds
  bool contains(Location location) {
    return location.latitude >= southwest.latitude &&
           location.latitude <= northeast.latitude &&
           location.longitude >= southwest.longitude &&
           location.longitude <= northeast.longitude;
  }

  // Get the center point of the bounds
  Location get center {
    return Location(
      latitude: (southwest.latitude + northeast.latitude) / 2,
      longitude: (southwest.longitude + northeast.longitude) / 2,
    );
  }

  @override
  List<Object?> get props => [southwest, northeast];
}

class Place extends Equatable {
  final String id;
  final String name;
  final String? address;
  final Location location;
  final String? placeId; // Google Places ID
  final List<String> types;
  final double? rating;
  final String? phoneNumber;
  final String? website;
  final Map<String, dynamic>? openingHours;

  const Place({
    required this.id,
    required this.name,
    this.address,
    required this.location,
    this.placeId,
    this.types = const [],
    this.rating,
    this.phoneNumber,
    this.website,
    this.openingHours,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      placeId: json['placeId'] as String?,
      types: List<String>.from(json['types'] ?? []),
      rating: (json['rating'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      openingHours: json['openingHours'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'location': location.toJson(),
      'placeId': placeId,
      'types': types,
      'rating': rating,
      'phoneNumber': phoneNumber,
      'website': website,
      'openingHours': openingHours,
    };
  }

  Place copyWith({
    String? id,
    String? name,
    String? address,
    Location? location,
    String? placeId,
    List<String>? types,
    double? rating,
    String? phoneNumber,
    String? website,
    Map<String, dynamic>? openingHours,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      location: location ?? this.location,
      placeId: placeId ?? this.placeId,
      types: types ?? this.types,
      rating: rating ?? this.rating,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        location,
        placeId,
        types,
        rating,
        phoneNumber,
        website,
        openingHours,
      ];
}

class SavedPlace extends Equatable {
  final String id;
  final String name;
  final String? nickname; // "Home", "Work", etc.
  final Location location;
  final String? address;
  final String? icon;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final int usageCount;

  const SavedPlace({
    required this.id,
    required this.name,
    this.nickname,
    required this.location,
    this.address,
    this.icon,
    required this.createdAt,
    this.lastUsedAt,
    this.usageCount = 0,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['id'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String?,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String?,
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt: json['lastUsedAt'] != null 
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'location': location.toJson(),
      'address': address,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'usageCount': usageCount,
    };
  }

  SavedPlace copyWith({
    String? id,
    String? name,
    String? nickname,
    Location? location,
    String? address,
    String? icon,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? usageCount,
  }) {
    return SavedPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      location: location ?? this.location,
      address: address ?? this.address,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nickname,
        location,
        address,
        icon,
        createdAt,
        lastUsedAt,
        usageCount,
      ];
}