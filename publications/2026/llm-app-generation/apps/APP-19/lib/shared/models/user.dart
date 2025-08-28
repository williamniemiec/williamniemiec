class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;
  final List<String> linkedAccounts;
  final bool biometricEnabled;
  final bool notificationsEnabled;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.profileImageUrl,
    this.linkedAccounts = const [],
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      profileImageUrl: json['profileImageUrl'],
      linkedAccounts: List<String>.from(json['linkedAccounts'] ?? []),
      biometricEnabled: json['biometricEnabled'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'linkedAccounts': linkedAccounts,
      'biometricEnabled': biometricEnabled,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    List<String>? linkedAccounts,
    bool? biometricEnabled,
    bool? notificationsEnabled,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}