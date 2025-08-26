import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final String membershipId;

  @HiveField(6)
  final MembershipType membershipType;

  @HiveField(7)
  final DateTime memberSince;

  @HiveField(8)
  final String? profileImageUrl;

  @HiveField(9)
  final bool isActive;

  @HiveField(10)
  final List<String> fitnessGoals;

  @HiveField(11)
  final String? emergencyContact;

  @HiveField(12)
  final String? emergencyContactPhone;

  @HiveField(13)
  final DateTime? lastCheckIn;

  @HiveField(14)
  final int guestPassesRemaining;

  @HiveField(15)
  final bool hasHealthKitAccess;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.membershipId,
    required this.membershipType,
    required this.memberSince,
    this.profileImageUrl,
    this.isActive = true,
    this.fitnessGoals = const [],
    this.emergencyContact,
    this.emergencyContactPhone,
    this.lastCheckIn,
    this.guestPassesRemaining = 0,
    this.hasHealthKitAccess = false,
  });

  String get fullName => '$firstName $lastName';

  String get membershipDisplayName {
    switch (membershipType) {
      case MembershipType.basic:
        return 'Basic';
      case MembershipType.premium:
        return 'Premium';
      case MembershipType.vip:
        return 'VIP';
    }
  }

  bool get canBringGuest => guestPassesRemaining > 0;

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? membershipId,
    MembershipType? membershipType,
    DateTime? memberSince,
    String? profileImageUrl,
    bool? isActive,
    List<String>? fitnessGoals,
    String? emergencyContact,
    String? emergencyContactPhone,
    DateTime? lastCheckIn,
    int? guestPassesRemaining,
    bool? hasHealthKitAccess,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      membershipId: membershipId ?? this.membershipId,
      membershipType: membershipType ?? this.membershipType,
      memberSince: memberSince ?? this.memberSince,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      guestPassesRemaining: guestPassesRemaining ?? this.guestPassesRemaining,
      hasHealthKitAccess: hasHealthKitAccess ?? this.hasHealthKitAccess,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'membershipId': membershipId,
      'membershipType': membershipType.name,
      'memberSince': memberSince.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'isActive': isActive,
      'fitnessGoals': fitnessGoals,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'lastCheckIn': lastCheckIn?.toIso8601String(),
      'guestPassesRemaining': guestPassesRemaining,
      'hasHealthKitAccess': hasHealthKitAccess,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      membershipId: json['membershipId'],
      membershipType: MembershipType.values.firstWhere(
        (e) => e.name == json['membershipType'],
        orElse: () => MembershipType.basic,
      ),
      memberSince: DateTime.parse(json['memberSince']),
      profileImageUrl: json['profileImageUrl'],
      isActive: json['isActive'] ?? true,
      fitnessGoals: List<String>.from(json['fitnessGoals'] ?? []),
      emergencyContact: json['emergencyContact'],
      emergencyContactPhone: json['emergencyContactPhone'],
      lastCheckIn: json['lastCheckIn'] != null 
          ? DateTime.parse(json['lastCheckIn']) 
          : null,
      guestPassesRemaining: json['guestPassesRemaining'] ?? 0,
      hasHealthKitAccess: json['hasHealthKitAccess'] ?? false,
    );
  }
}

@HiveType(typeId: 1)
enum MembershipType {
  @HiveField(0)
  basic,
  @HiveField(1)
  premium,
  @HiveField(2)
  vip,
}