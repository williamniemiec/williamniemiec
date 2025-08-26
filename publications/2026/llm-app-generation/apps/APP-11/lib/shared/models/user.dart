class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final double paypalBalance;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.paypalBalance,
    required this.isVerified,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferences,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      paypalBalance: (json['paypalBalance'] as num).toDouble(),
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      preferences: UserPreferences.fromJson(json['preferences']),
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
      'paypalBalance': paypalBalance,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'preferences': preferences.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    double? paypalBalance,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      paypalBalance: paypalBalance ?? this.paypalBalance,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserPreferences {
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String currency;
  final String language;

  UserPreferences({
    required this.biometricEnabled,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.currency,
    required this.language,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      biometricEnabled: json['biometricEnabled'],
      notificationsEnabled: json['notificationsEnabled'],
      darkModeEnabled: json['darkModeEnabled'],
      currency: json['currency'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'biometricEnabled': biometricEnabled,
      'notificationsEnabled': notificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'currency': currency,
      'language': language,
    };
  }

  UserPreferences copyWith({
    bool? biometricEnabled,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? currency,
    String? language,
  }) {
    return UserPreferences(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      currency: currency ?? this.currency,
      language: language ?? this.language,
    );
  }
}