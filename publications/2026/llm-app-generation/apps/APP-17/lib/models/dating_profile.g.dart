// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dating_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatingProfile _$DatingProfileFromJson(Map<String, dynamic> json) =>
    DatingProfile(
      id: json['id'] as String,
      bio: json['bio'] as String,
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      age: (json['age'] as num?)?.toInt(),
      location: json['location'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastRoastedAt: json['lastRoastedAt'] == null
          ? null
          : DateTime.parse(json['lastRoastedAt'] as String),
      roastScore: (json['roastScore'] as num?)?.toDouble(),
      roastFeedback: (json['roastFeedback'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DatingProfileToJson(DatingProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bio': instance.bio,
      'photoUrls': instance.photoUrls,
      'age': instance.age,
      'location': instance.location,
      'interests': instance.interests,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastRoastedAt': instance.lastRoastedAt?.toIso8601String(),
      'roastScore': instance.roastScore,
      'roastFeedback': instance.roastFeedback,
    };
