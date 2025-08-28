import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final double rating;
  final int totalTrips;
  final DateTime createdAt;
  final List<String> savedLocations;
  final List<PaymentMethod> paymentMethods;
  final String? defaultPaymentMethodId;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.rating = 5.0,
    this.totalTrips = 0,
    required this.createdAt,
    this.savedLocations = const [],
    this.paymentMethods = const [],
    this.defaultPaymentMethodId,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    double? rating,
    int? totalTrips,
    DateTime? createdAt,
    List<String>? savedLocations,
    List<PaymentMethod>? paymentMethods,
    String? defaultPaymentMethodId,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      createdAt: createdAt ?? this.createdAt,
      savedLocations: savedLocations ?? this.savedLocations,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      defaultPaymentMethodId: defaultPaymentMethodId ?? this.defaultPaymentMethodId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalTrips': totalTrips,
      'createdAt': createdAt.toIso8601String(),
      'savedLocations': savedLocations,
      'paymentMethods': paymentMethods.map((pm) => pm.toJson()).toList(),
      'defaultPaymentMethodId': defaultPaymentMethodId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalTrips: json['totalTrips'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      savedLocations: List<String>.from(json['savedLocations'] ?? []),
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((pm) => PaymentMethod.fromJson(pm as Map<String, dynamic>))
          .toList() ?? [],
      defaultPaymentMethodId: json['defaultPaymentMethodId'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        profileImageUrl,
        rating,
        totalTrips,
        createdAt,
        savedLocations,
        paymentMethods,
        defaultPaymentMethodId,
      ];
}

class PaymentMethod extends Equatable {
  final String id;
  final String type; // 'credit_card', 'debit_card', 'paypal', etc.
  final String displayName;
  final String? last4Digits;
  final String? brand; // 'visa', 'mastercard', etc.
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    this.last4Digits,
    this.brand,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? displayName,
    String? last4Digits,
    String? brand,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      last4Digits: last4Digits ?? this.last4Digits,
      brand: brand ?? this.brand,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'displayName': displayName,
      'last4Digits': last4Digits,
      'brand': brand,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      displayName: json['displayName'] as String,
      last4Digits: json['last4Digits'] as String?,
      brand: json['brand'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, type, displayName, last4Digits, brand, isDefault];
}