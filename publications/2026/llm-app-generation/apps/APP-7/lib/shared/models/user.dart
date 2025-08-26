class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserRole role;
  final List<String> childrenIds;
  final String? schoolId;
  final String? districtId;
  final String preferredLanguage;
  final NotificationSettings notificationSettings;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.role,
    required this.childrenIds,
    this.schoolId,
    this.districtId,
    this.preferredLanguage = 'en',
    required this.notificationSettings,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      childrenIds: List<String>.from(json['childrenIds'] ?? []),
      schoolId: json['schoolId'],
      districtId: json['districtId'],
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      notificationSettings: NotificationSettings.fromJson(json['notificationSettings']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'role': role.name,
      'childrenIds': childrenIds,
      'schoolId': schoolId,
      'districtId': districtId,
      'preferredLanguage': preferredLanguage,
      'notificationSettings': notificationSettings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    UserRole? role,
    List<String>? childrenIds,
    String? schoolId,
    String? districtId,
    String? preferredLanguage,
    NotificationSettings? notificationSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      childrenIds: childrenIds ?? this.childrenIds,
      schoolId: schoolId ?? this.schoolId,
      districtId: districtId ?? this.districtId,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum UserRole {
  parent,
  teacher,
  staff,
  admin,
}

class NotificationSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final NotificationFrequency frequency;
  final List<NotificationType> enabledTypes;

  NotificationSettings({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.frequency = NotificationFrequency.instant,
    this.enabledTypes = const [
      NotificationType.announcements,
      NotificationType.messages,
      NotificationType.events,
      NotificationType.attendance,
    ],
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      frequency: NotificationFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => NotificationFrequency.instant,
      ),
      enabledTypes: (json['enabledTypes'] as List<dynamic>?)
          ?.map((e) => NotificationType.values.firstWhere((type) => type.name == e))
          .toList() ?? [
        NotificationType.announcements,
        NotificationType.messages,
        NotificationType.events,
        NotificationType.attendance,
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'frequency': frequency.name,
      'enabledTypes': enabledTypes.map((e) => e.name).toList(),
    };
  }
}

enum NotificationFrequency {
  instant,
  digest,
}

enum NotificationType {
  announcements,
  messages,
  events,
  attendance,
  forms,
  payments,
}