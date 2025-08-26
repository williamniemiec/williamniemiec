class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final DateTime? birthDate;
  final List<String> savedAddresses;
  final List<String> savedPaymentMethods;
  final String? profileImageUrl;
  final bool emailNotifications;
  final bool pushNotifications;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.birthDate,
    this.savedAddresses = const [],
    this.savedPaymentMethods = const [],
    this.profileImageUrl,
    this.emailNotifications = true,
    this.pushNotifications = true,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  bool get isBirthdayMonth {
    if (birthDate == null) return false;
    final now = DateTime.now();
    return birthDate!.month == now.month;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      savedAddresses: List<String>.from(json['savedAddresses'] as List? ?? []),
      savedPaymentMethods: List<String>.from(json['savedPaymentMethods'] as List? ?? []),
      profileImageUrl: json['profileImageUrl'] as String?,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'birthDate': birthDate?.toIso8601String(),
      'savedAddresses': savedAddresses,
      'savedPaymentMethods': savedPaymentMethods,
      'profileImageUrl': profileImageUrl,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? birthDate,
    List<String>? savedAddresses,
    List<String>? savedPaymentMethods,
    String? profileImageUrl,
    bool? emailNotifications,
    bool? pushNotifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      savedPaymentMethods: savedPaymentMethods ?? this.savedPaymentMethods,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $fullName, email: $email)';
  }
}