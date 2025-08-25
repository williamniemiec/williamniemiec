// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      subscription: UserSubscription.fromJson(
          json['subscription'] as Map<String, dynamic>),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      usage: UserUsage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'subscription': instance.subscription,
      'preferences': instance.preferences,
      'usage': instance.usage,
    };

UserSubscription _$UserSubscriptionFromJson(Map<String, dynamic> json) =>
    UserSubscription(
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserSubscriptionToJson(UserSubscription instance) =>
    <String, dynamic>{
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isActive': instance.isActive,
      'features': instance.features,
    };

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.free: 'free',
  SubscriptionTier.pro: 'pro',
  SubscriptionTier.teams: 'teams',
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      autoSave: json['autoSave'] as bool? ?? true,
      gridEnabled: json['gridEnabled'] as bool? ?? false,
      snapToGrid: json['snapToGrid'] as bool? ?? true,
      showRulers: json['showRulers'] as bool? ?? false,
      defaultExportFormat: json['defaultExportFormat'] as String? ?? 'PNG',
      defaultExportQuality:
          (json['defaultExportQuality'] as num?)?.toInt() ?? 100,
      language: json['language'] as String? ?? 'en',
      darkMode: json['darkMode'] as bool? ?? false,
      notifications: json['notifications'] as bool? ?? true,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'autoSave': instance.autoSave,
      'gridEnabled': instance.gridEnabled,
      'snapToGrid': instance.snapToGrid,
      'showRulers': instance.showRulers,
      'defaultExportFormat': instance.defaultExportFormat,
      'defaultExportQuality': instance.defaultExportQuality,
      'language': instance.language,
      'darkMode': instance.darkMode,
      'notifications': instance.notifications,
    };

UserUsage _$UserUsageFromJson(Map<String, dynamic> json) => UserUsage(
      designsCreated: (json['designsCreated'] as num?)?.toInt() ?? 0,
      templatesUsed: (json['templatesUsed'] as num?)?.toInt() ?? 0,
      exportsThisMonth: (json['exportsThisMonth'] as num?)?.toInt() ?? 0,
      storageUsedMB: (json['storageUsedMB'] as num?)?.toInt() ?? 0,
      aiGenerationsUsed: (json['aiGenerationsUsed'] as num?)?.toInt() ?? 0,
      lastActive: DateTime.parse(json['lastActive'] as String),
    );

Map<String, dynamic> _$UserUsageToJson(UserUsage instance) => <String, dynamic>{
      'designsCreated': instance.designsCreated,
      'templatesUsed': instance.templatesUsed,
      'exportsThisMonth': instance.exportsThisMonth,
      'storageUsedMB': instance.storageUsedMB,
      'aiGenerationsUsed': instance.aiGenerationsUsed,
      'lastActive': instance.lastActive.toIso8601String(),
    };
