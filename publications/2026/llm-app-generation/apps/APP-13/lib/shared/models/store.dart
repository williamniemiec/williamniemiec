class Store {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final double latitude;
  final double longitude;
  final Map<String, String> hours; // day -> hours (e.g., "monday" -> "8:00 AM - 10:00 PM")
  final bool isOpen;
  final bool acceptsOrders;
  final double deliveryRadius; // in miles
  final double deliveryFee;
  final int estimatedPickupTime; // in minutes
  final int estimatedDeliveryTime; // in minutes

  const Store({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.hours,
    required this.isOpen,
    required this.acceptsOrders,
    required this.deliveryRadius,
    required this.deliveryFee,
    required this.estimatedPickupTime,
    required this.estimatedDeliveryTime,
  });

  String get fullAddress => '$address, $city, $state $zipCode';

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      phone: json['phone'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      hours: Map<String, String>.from(json['hours'] as Map),
      isOpen: json['isOpen'] as bool,
      acceptsOrders: json['acceptsOrders'] as bool,
      deliveryRadius: (json['deliveryRadius'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      estimatedPickupTime: json['estimatedPickupTime'] as int,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'hours': hours,
      'isOpen': isOpen,
      'acceptsOrders': acceptsOrders,
      'deliveryRadius': deliveryRadius,
      'deliveryFee': deliveryFee,
      'estimatedPickupTime': estimatedPickupTime,
      'estimatedDeliveryTime': estimatedDeliveryTime,
    };
  }

  Store copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? phone,
    double? latitude,
    double? longitude,
    Map<String, String>? hours,
    bool? isOpen,
    bool? acceptsOrders,
    double? deliveryRadius,
    double? deliveryFee,
    int? estimatedPickupTime,
    int? estimatedDeliveryTime,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      hours: hours ?? this.hours,
      isOpen: isOpen ?? this.isOpen,
      acceptsOrders: acceptsOrders ?? this.acceptsOrders,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Store && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Store(id: $id, name: $name, city: $city)';
  }
}