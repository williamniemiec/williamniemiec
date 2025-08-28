class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String membershipLevel;
  final int loyaltyPoints;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.dateOfBirth,
    this.gender = '',
    this.addresses = const [],
    this.paymentMethods = const [],
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.membershipLevel = 'Bronze',
    this.loyaltyPoints = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      gender: json['gender'] ?? '',
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e))
          .toList() ?? [],
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e))
          .toList() ?? [],
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      membershipLevel: json['membershipLevel'] ?? 'Bronze',
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      'preferences': preferences.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'membershipLevel': membershipLevel,
      'loyaltyPoints': loyaltyPoints,
    };
  }

  String get fullName => '$firstName $lastName';
  
  Address? get defaultAddress => addresses.isNotEmpty 
      ? addresses.firstWhere((addr) => addr.isDefault, orElse: () => addresses.first)
      : null;
      
  PaymentMethod? get defaultPaymentMethod => paymentMethods.isNotEmpty
      ? paymentMethods.firstWhere((pm) => pm.isDefault, orElse: () => paymentMethods.first)
      : null;

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    List<Address>? addresses,
    List<PaymentMethod>? paymentMethods,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? membershipLevel,
    int? loyaltyPoints,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    );
  }
}

class Address {
  final String id;
  final String label;
  final String firstName;
  final String lastName;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phoneNumber;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.firstName,
    required this.lastName,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phoneNumber,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      phoneNumber: json['phoneNumber'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'firstName': firstName,
      'lastName': lastName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
    };
  }

  String get fullName => '$firstName $lastName';
  
  String get fullAddress {
    final line2 = addressLine2?.isNotEmpty == true ? ', $addressLine2' : '';
    return '$addressLine1$line2, $city, $state $zipCode, $country';
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String cardNumber;
  final String cardHolderName;
  final String expiryMonth;
  final String expiryYear;
  final String? billingAddressId;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryMonth,
    required this.expiryYear,
    this.billingAddressId,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      cardHolderName: json['cardHolderName'] ?? '',
      expiryMonth: json['expiryMonth'] ?? '',
      expiryYear: json['expiryYear'] ?? '',
      billingAddressId: json['billingAddressId'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'billingAddressId': billingAddressId,
      'isDefault': isDefault,
    };
  }

  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }
}

class UserPreferences {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool marketingEmails;
  final String currency;
  final String language;
  final String sizePreference;
  final List<String> favoriteCategories;
  final List<String> favoriteColors;
  final List<String> favoriteBrands;

  UserPreferences({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.marketingEmails = true,
    this.currency = 'USD',
    this.language = 'en',
    this.sizePreference = 'M',
    this.favoriteCategories = const [],
    this.favoriteColors = const [],
    this.favoriteBrands = const [],
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      marketingEmails: json['marketingEmails'] ?? true,
      currency: json['currency'] ?? 'USD',
      language: json['language'] ?? 'en',
      sizePreference: json['sizePreference'] ?? 'M',
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      favoriteColors: List<String>.from(json['favoriteColors'] ?? []),
      favoriteBrands: List<String>.from(json['favoriteBrands'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'marketingEmails': marketingEmails,
      'currency': currency,
      'language': language,
      'sizePreference': sizePreference,
      'favoriteCategories': favoriteCategories,
      'favoriteColors': favoriteColors,
      'favoriteBrands': favoriteBrands,
    };
  }

  UserPreferences copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? marketingEmails,
    String? currency,
    String? language,
    String? sizePreference,
    List<String>? favoriteCategories,
    List<String>? favoriteColors,
    List<String>? favoriteBrands,
  }) {
    return UserPreferences(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      sizePreference: sizePreference ?? this.sizePreference,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      favoriteColors: favoriteColors ?? this.favoriteColors,
      favoriteBrands: favoriteBrands ?? this.favoriteBrands,
    );
  }
}