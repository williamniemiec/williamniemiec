class WeatherLocation {
  final String id;
  final String name;
  final String country;
  final String region;
  final double latitude;
  final double longitude;
  final bool isCurrentLocation;
  final DateTime? lastUpdated;

  const WeatherLocation({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
    this.isCurrentLocation = false,
    this.lastUpdated,
  });

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      region: json['region'] ?? '',
      latitude: (json['lat'] ?? json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['lon'] ?? json['longitude'] ?? 0.0).toDouble(),
      isCurrentLocation: json['isCurrentLocation'] ?? false,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'isCurrentLocation': isCurrentLocation,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  WeatherLocation copyWith({
    String? id,
    String? name,
    String? country,
    String? region,
    double? latitude,
    double? longitude,
    bool? isCurrentLocation,
    DateTime? lastUpdated,
  }) {
    return WeatherLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      region: region ?? this.region,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'WeatherLocation(id: $id, name: $name, country: $country, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherLocation &&
        other.id == id &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
  }
}