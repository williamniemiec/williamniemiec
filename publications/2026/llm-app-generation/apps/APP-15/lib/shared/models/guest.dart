import 'package:hive/hive.dart';

part 'guest.g.dart';

@HiveType(typeId: 13)
class Guest extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String memberId;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? phoneNumber;

  @HiveField(6)
  final DateTime visitDate;

  @HiveField(7)
  final String locationId;

  @HiveField(8)
  final GuestStatus status;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? checkedInAt;

  @HiveField(11)
  final DateTime? checkedOutAt;

  @HiveField(12)
  final bool hasWaiver;

  @HiveField(13)
  final String? emergencyContact;

  @HiveField(14)
  final String? emergencyContactPhone;

  Guest({
    required this.id,
    required this.memberId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    required this.visitDate,
    required this.locationId,
    required this.status,
    required this.createdAt,
    this.checkedInAt,
    this.checkedOutAt,
    this.hasWaiver = false,
    this.emergencyContact,
    this.emergencyContactPhone,
  });

  String get fullName => '$firstName $lastName';

  String get statusDisplayName {
    switch (status) {
      case GuestStatus.pending:
        return 'Pending';
      case GuestStatus.approved:
        return 'Approved';
      case GuestStatus.checkedIn:
        return 'Checked In';
      case GuestStatus.checkedOut:
        return 'Checked Out';
      case GuestStatus.expired:
        return 'Expired';
      case GuestStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive => status == GuestStatus.approved || status == GuestStatus.checkedIn;
  bool get canCheckIn => status == GuestStatus.approved && DateTime.now().isBefore(visitDate.add(const Duration(days: 1)));

  Guest copyWith({
    String? id,
    String? memberId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? visitDate,
    String? locationId,
    GuestStatus? status,
    DateTime? createdAt,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    bool? hasWaiver,
    String? emergencyContact,
    String? emergencyContactPhone,
  }) {
    return Guest(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      visitDate: visitDate ?? this.visitDate,
      locationId: locationId ?? this.locationId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      hasWaiver: hasWaiver ?? this.hasWaiver,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'visitDate': visitDate.toIso8601String(),
      'locationId': locationId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'checkedInAt': checkedInAt?.toIso8601String(),
      'checkedOutAt': checkedOutAt?.toIso8601String(),
      'hasWaiver': hasWaiver,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
    };
  }

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      memberId: json['memberId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      visitDate: DateTime.parse(json['visitDate']),
      locationId: json['locationId'],
      status: GuestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GuestStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      checkedInAt: json['checkedInAt'] != null 
          ? DateTime.parse(json['checkedInAt']) 
          : null,
      checkedOutAt: json['checkedOutAt'] != null 
          ? DateTime.parse(json['checkedOutAt']) 
          : null,
      hasWaiver: json['hasWaiver'] ?? false,
      emergencyContact: json['emergencyContact'],
      emergencyContactPhone: json['emergencyContactPhone'],
    );
  }
}

@HiveType(typeId: 14)
enum GuestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  approved,
  @HiveField(2)
  checkedIn,
  @HiveField(3)
  checkedOut,
  @HiveField(4)
  expired,
  @HiveField(5)
  cancelled,
}