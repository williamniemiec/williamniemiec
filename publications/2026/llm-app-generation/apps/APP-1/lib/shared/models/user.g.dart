// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      membershipType:
          $enumDecode(_$MembershipTypeEnumMap, json['membershipType']),
      creditsRemaining: (json['creditsRemaining'] as num).toInt(),
      membershipExpiry: DateTime.parse(json['membershipExpiry'] as String),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'membershipType': _$MembershipTypeEnumMap[instance.membershipType]!,
      'creditsRemaining': instance.creditsRemaining,
      'membershipExpiry': instance.membershipExpiry.toIso8601String(),
      'preferences': instance.preferences,
      'stats': instance.stats,
    };

const _$MembershipTypeEnumMap = {
  MembershipType.free: 'free',
  MembershipType.plus: 'plus',
  MembershipType.premiumPlus: 'premium_plus',
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
      skipForwardSeconds: (json['skipForwardSeconds'] as num?)?.toInt() ?? 30,
      skipBackwardSeconds: (json['skipBackwardSeconds'] as num?)?.toInt() ?? 30,
      autoPlay: json['autoPlay'] as bool? ?? true,
      downloadOnWifi: json['downloadOnWifi'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'playbackSpeed': instance.playbackSpeed,
      'skipForwardSeconds': instance.skipForwardSeconds,
      'skipBackwardSeconds': instance.skipBackwardSeconds,
      'autoPlay': instance.autoPlay,
      'downloadOnWifi': instance.downloadOnWifi,
      'darkMode': instance.darkMode,
      'notificationsEnabled': instance.notificationsEnabled,
    };

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
      totalListeningTime:
          Duration(microseconds: (json['totalListeningTime'] as num).toInt()),
      booksCompleted: (json['booksCompleted'] as num).toInt(),
      podcastsListened: (json['podcastsListened'] as num).toInt(),
      badges:
          (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
      'totalListeningTime': instance.totalListeningTime.inMicroseconds,
      'booksCompleted': instance.booksCompleted,
      'podcastsListened': instance.podcastsListened,
      'badges': instance.badges,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
    };
