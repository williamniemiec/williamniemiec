// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPremium: json['isPremium'] as bool? ?? false,
      premiumExpiresAt: json['premiumExpiresAt'] == null
          ? null
          : DateTime.parse(json['premiumExpiresAt'] as String),
      dailyUsageCount: (json['dailyUsageCount'] as num?)?.toInt() ?? 0,
      lastUsageReset: json['lastUsageReset'] == null
          ? null
          : DateTime.parse(json['lastUsageReset'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'isPremium': instance.isPremium,
      'premiumExpiresAt': instance.premiumExpiresAt?.toIso8601String(),
      'dailyUsageCount': instance.dailyUsageCount,
      'lastUsageReset': instance.lastUsageReset?.toIso8601String(),
    };
