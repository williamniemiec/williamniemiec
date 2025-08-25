import 'package:json_annotation/json_annotation.dart';

part 'business_profile.g.dart';

@JsonSerializable()
class BusinessProfile {
  final String id;
  final String businessName;
  final String? description;
  final String? category;
  final String? logoUrl;
  final String? email;
  final String? website;
  final String? address;
  final BusinessHours? businessHours;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BusinessProfile({
    required this.id,
    required this.businessName,
    this.description,
    this.category,
    this.logoUrl,
    this.email,
    this.website,
    this.address,
    this.businessHours,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessProfileToJson(this);

  BusinessProfile copyWith({
    String? id,
    String? businessName,
    String? description,
    String? category,
    String? logoUrl,
    String? email,
    String? website,
    String? address,
    BusinessHours? businessHours,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessProfile(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      description: description ?? this.description,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      businessHours: businessHours ?? this.businessHours,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class BusinessHours {
  final Map<String, DayHours> schedule;
  final String timezone;

  const BusinessHours({
    required this.schedule,
    required this.timezone,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) =>
      _$BusinessHoursFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessHoursToJson(this);
}

@JsonSerializable()
class DayHours {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;

  const DayHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory DayHours.fromJson(Map<String, dynamic> json) =>
      _$DayHoursFromJson(json);

  Map<String, dynamic> toJson() => _$DayHoursToJson(this);
}