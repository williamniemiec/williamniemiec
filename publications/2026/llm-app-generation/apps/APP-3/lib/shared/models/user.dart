import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String displayName;

  @HiveField(3)
  final String? firstName;

  @HiveField(4)
  final String? lastName;

  @HiveField(5)
  final String? profilePictureUrl;

  @HiveField(6)
  final String? jobTitle;

  @HiveField(7)
  final String? department;

  @HiveField(8)
  final String? phoneNumber;

  @HiveField(9)
  final UserStatus status;

  @HiveField(10)
  final String? statusMessage;

  @HiveField(11)
  final DateTime? lastSeen;

  @HiveField(12)
  final bool isOnline;

  @HiveField(13)
  final List<String> teamIds;

  @HiveField(14)
  final UserRole role;

  @HiveField(15)
  final DateTime createdAt;

  @HiveField(16)
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePictureUrl,
    this.jobTitle,
    this.department,
    this.phoneNumber,
    this.status = UserStatus.available,
    this.statusMessage,
    this.lastSeen,
    this.isOnline = false,
    this.teamIds = const [],
    this.role = UserRole.member,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      jobTitle: json['jobTitle'] as String?,
      department: json['department'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      status: UserStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => UserStatus.available,
      ),
      statusMessage: json['statusMessage'] as String?,
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      isOnline: json['isOnline'] as bool? ?? false,
      teamIds: List<String>.from(json['teamIds'] as List? ?? []),
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.member,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureUrl': profilePictureUrl,
      'jobTitle': jobTitle,
      'department': department,
      'phoneNumber': phoneNumber,
      'status': status.toString().split('.').last,
      'statusMessage': statusMessage,
      'lastSeen': lastSeen?.toIso8601String(),
      'isOnline': isOnline,
      'teamIds': teamIds,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? profilePictureUrl,
    String? jobTitle,
    String? department,
    String? phoneNumber,
    UserStatus? status,
    String? statusMessage,
    DateTime? lastSeen,
    bool? isOnline,
    List<String>? teamIds,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      jobTitle: jobTitle ?? this.jobTitle,
      department: department ?? this.department,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      teamIds: teamIds ?? this.teamIds,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName;
  }

  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }
}

@HiveType(typeId: 1)
enum UserStatus {
  @HiveField(0)
  available,
  @HiveField(1)
  busy,
  @HiveField(2)
  doNotDisturb,
  @HiveField(3)
  away,
  @HiveField(4)
  offline,
}

@HiveType(typeId: 2)
enum UserRole {
  @HiveField(0)
  member,
  @HiveField(1)
  admin,
  @HiveField(2)
  owner,
  @HiveField(3)
  guest,
}