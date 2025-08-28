import 'coupon.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String? phoneNumber;
  final List<Address> addresses;
  final double credits;
  final List<Coupon> coupons;
  final int totalOrders;
  final double totalSpent;
  final DateTime joinDate;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.phoneNumber,
    required this.addresses,
    required this.credits,
    required this.coupons,
    required this.totalOrders,
    required this.totalSpent,
    required this.joinDate,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      phoneNumber: json['phoneNumber'],
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((a) => Address.fromJson(a))
              .toList() ??
          [],
      credits: (json['credits'] ?? 0).toDouble(),
      coupons: (json['coupons'] as List<dynamic>?)
              ?.map((c) => Coupon.fromJson(c))
              .toList() ??
          [],
      totalOrders: json['totalOrders'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'addresses': addresses.map((a) => a.toJson()).toList(),
      'credits': credits,
      'coupons': coupons.map((c) => c.toJson()).toList(),
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'joinDate': joinDate.toIso8601String(),
      'preferences': preferences.toJson(),
    };
  }
}

class Address {
  final String id;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }
}

class UserPreferences {
  final bool notificationsEnabled;
  final bool emailMarketing;
  final String language;
  final String currency;

  UserPreferences({
    required this.notificationsEnabled,
    required this.emailMarketing,
    required this.language,
    required this.currency,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailMarketing: json['emailMarketing'] ?? false,
      language: json['language'] ?? 'en',
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'emailMarketing': emailMarketing,
      'language': language,
      'currency': currency,
    };
  }
}