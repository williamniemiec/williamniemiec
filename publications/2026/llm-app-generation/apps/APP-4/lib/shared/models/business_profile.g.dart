// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) =>
    BusinessProfile(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      logoUrl: json['logoUrl'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      businessHours: json['businessHours'] == null
          ? null
          : BusinessHours.fromJson(
              json['businessHours'] as Map<String, dynamic>,
            ),
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BusinessProfileToJson(BusinessProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'description': instance.description,
      'category': instance.category,
      'logoUrl': instance.logoUrl,
      'email': instance.email,
      'website': instance.website,
      'address': instance.address,
      'businessHours': instance.businessHours,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) =>
    BusinessHours(
      schedule: (json['schedule'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DayHours.fromJson(e as Map<String, dynamic>)),
      ),
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$BusinessHoursToJson(BusinessHours instance) =>
    <String, dynamic>{
      'schedule': instance.schedule,
      'timezone': instance.timezone,
    };

DayHours _$DayHoursFromJson(Map<String, dynamic> json) => DayHours(
  isOpen: json['isOpen'] as bool,
  openTime: json['openTime'] as String?,
  closeTime: json['closeTime'] as String?,
);

Map<String, dynamic> _$DayHoursToJson(DayHours instance) => <String, dynamic>{
  'isOpen': instance.isOpen,
  'openTime': instance.openTime,
  'closeTime': instance.closeTime,
};
