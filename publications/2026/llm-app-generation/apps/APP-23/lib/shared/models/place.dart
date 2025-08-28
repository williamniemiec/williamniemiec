import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final String? phoneNumber;
  final String? website;
  final List<String> types;
  final double? rating;
  final int? userRatingsTotal;
  final List<String> photos;
  final PlaceOpeningHours? openingHours;
  final String? priceLevel;
  final bool isPermanentlyClosed;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    this.phoneNumber,
    this.website,
    this.types = const [],
    this.rating,
    this.userRatingsTotal,
    this.photos = const [],
    this.openingHours,
    this.priceLevel,
    this.isPermanentlyClosed = false,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['formatted_address'] ?? json['vicinity'] ?? '',
      location: LatLng(
        json['geometry']['location']['lat']?.toDouble() ?? 0.0,
        json['geometry']['location']['lng']?.toDouble() ?? 0.0,
      ),
      phoneNumber: json['formatted_phone_number'],
      website: json['website'],
      types: List<String>.from(json['types'] ?? []),
      rating: json['rating']?.toDouble(),
      userRatingsTotal: json['user_ratings_total'],
      photos: (json['photos'] as List?)
          ?.map((photo) => photo['photo_reference'] as String)
          .toList() ?? [],
      openingHours: json['opening_hours'] != null
          ? PlaceOpeningHours.fromJson(json['opening_hours'])
          : null,
      priceLevel: json['price_level']?.toString(),
      isPermanentlyClosed: json['permanently_closed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': id,
      'name': name,
      'formatted_address': address,
      'geometry': {
        'location': {
          'lat': location.latitude,
          'lng': location.longitude,
        },
      },
      'formatted_phone_number': phoneNumber,
      'website': website,
      'types': types,
      'rating': rating,
      'user_ratings_total': userRatingsTotal,
      'photos': photos.map((photo) => {'photo_reference': photo}).toList(),
      'opening_hours': openingHours?.toJson(),
      'price_level': priceLevel,
      'permanently_closed': isPermanentlyClosed,
    };
  }

  Place copyWith({
    String? id,
    String? name,
    String? address,
    LatLng? location,
    String? phoneNumber,
    String? website,
    List<String>? types,
    double? rating,
    int? userRatingsTotal,
    List<String>? photos,
    PlaceOpeningHours? openingHours,
    String? priceLevel,
    bool? isPermanentlyClosed,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      types: types ?? this.types,
      rating: rating ?? this.rating,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      photos: photos ?? this.photos,
      openingHours: openingHours ?? this.openingHours,
      priceLevel: priceLevel ?? this.priceLevel,
      isPermanentlyClosed: isPermanentlyClosed ?? this.isPermanentlyClosed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Place && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Place(id: $id, name: $name, address: $address)';
  }
}

class PlaceOpeningHours {
  final bool openNow;
  final List<String> weekdayText;

  PlaceOpeningHours({
    required this.openNow,
    required this.weekdayText,
  });

  factory PlaceOpeningHours.fromJson(Map<String, dynamic> json) {
    return PlaceOpeningHours(
      openNow: json['open_now'] ?? false,
      weekdayText: List<String>.from(json['weekday_text'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open_now': openNow,
      'weekday_text': weekdayText,
    };
  }
}