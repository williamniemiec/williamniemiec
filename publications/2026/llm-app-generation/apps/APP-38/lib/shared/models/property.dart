class Property {
  final String id;
  final String name;
  final String description;
  final String type; // Hotel, Apartment, etc.
  final int starRating;
  final double reviewScore;
  final int reviewCount;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final List<String> images;
  final List<String> amenities;
  final List<Room> rooms;
  final bool freeCancellation;
  final bool bookNowPayLater;
  final bool instantConfirmation;
  final double? discountPercentage;
  final String? geniusDiscount;
  final bool isWishlisted;

  Property({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.starRating,
    required this.reviewScore,
    required this.reviewCount,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.amenities,
    required this.rooms,
    this.freeCancellation = false,
    this.bookNowPayLater = false,
    this.instantConfirmation = false,
    this.discountPercentage,
    this.geniusDiscount,
    this.isWishlisted = false,
  });

  String get fullAddress => '$address, $city, $country';
  
  String get reviewScoreText {
    if (reviewScore >= 9.0) return 'Wonderful';
    if (reviewScore >= 8.0) return 'Very good';
    if (reviewScore >= 7.0) return 'Good';
    if (reviewScore >= 6.0) return 'Pleasant';
    return 'Fair';
  }

  double get lowestPrice {
    if (rooms.isEmpty) return 0.0;
    return rooms.map((room) => room.pricePerNight).reduce((a, b) => a < b ? a : b);
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      starRating: json['starRating'] as int,
      reviewScore: (json['reviewScore'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      rooms: (json['rooms'] as List).map((room) => Room.fromJson(room)).toList(),
      freeCancellation: json['freeCancellation'] as bool? ?? false,
      bookNowPayLater: json['bookNowPayLater'] as bool? ?? false,
      instantConfirmation: json['instantConfirmation'] as bool? ?? false,
      discountPercentage: json['discountPercentage'] as double?,
      geniusDiscount: json['geniusDiscount'] as String?,
      isWishlisted: json['isWishlisted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'starRating': starRating,
      'reviewScore': reviewScore,
      'reviewCount': reviewCount,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'amenities': amenities,
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'freeCancellation': freeCancellation,
      'bookNowPayLater': bookNowPayLater,
      'instantConfirmation': instantConfirmation,
      'discountPercentage': discountPercentage,
      'geniusDiscount': geniusDiscount,
      'isWishlisted': isWishlisted,
    };
  }

  Property copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    int? starRating,
    double? reviewScore,
    int? reviewCount,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    List<String>? images,
    List<String>? amenities,
    List<Room>? rooms,
    bool? freeCancellation,
    bool? bookNowPayLater,
    bool? instantConfirmation,
    double? discountPercentage,
    String? geniusDiscount,
    bool? isWishlisted,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      starRating: starRating ?? this.starRating,
      reviewScore: reviewScore ?? this.reviewScore,
      reviewCount: reviewCount ?? this.reviewCount,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      rooms: rooms ?? this.rooms,
      freeCancellation: freeCancellation ?? this.freeCancellation,
      bookNowPayLater: bookNowPayLater ?? this.bookNowPayLater,
      instantConfirmation: instantConfirmation ?? this.instantConfirmation,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      geniusDiscount: geniusDiscount ?? this.geniusDiscount,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Property && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Property(id: $id, name: $name, type: $type)';
  }
}

class Room {
  final String id;
  final String name;
  final String description;
  final int maxOccupancy;
  final double pricePerNight;
  final double? originalPrice;
  final String bedType;
  final double roomSize;
  final List<String> amenities;
  final bool freeCancellation;
  final bool breakfastIncluded;
  final bool refundable;
  final int availableRooms;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.maxOccupancy,
    required this.pricePerNight,
    this.originalPrice,
    required this.bedType,
    required this.roomSize,
    required this.amenities,
    this.freeCancellation = false,
    this.breakfastIncluded = false,
    this.refundable = false,
    required this.availableRooms,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > pricePerNight;
  
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((originalPrice! - pricePerNight) / originalPrice!) * 100;
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      maxOccupancy: json['maxOccupancy'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      originalPrice: json['originalPrice'] as double?,
      bedType: json['bedType'] as String,
      roomSize: (json['roomSize'] as num).toDouble(),
      amenities: List<String>.from(json['amenities'] as List),
      freeCancellation: json['freeCancellation'] as bool? ?? false,
      breakfastIncluded: json['breakfastIncluded'] as bool? ?? false,
      refundable: json['refundable'] as bool? ?? false,
      availableRooms: json['availableRooms'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'maxOccupancy': maxOccupancy,
      'pricePerNight': pricePerNight,
      'originalPrice': originalPrice,
      'bedType': bedType,
      'roomSize': roomSize,
      'amenities': amenities,
      'freeCancellation': freeCancellation,
      'breakfastIncluded': breakfastIncluded,
      'refundable': refundable,
      'availableRooms': availableRooms,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Room && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Room(id: $id, name: $name, price: \$${pricePerNight.toStringAsFixed(2)})';
  }
}