import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final MembershipType membershipType;
  final int creditsRemaining;
  final DateTime membershipExpiry;
  final UserPreferences preferences;
  final UserStats stats;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.membershipType,
    required this.creditsRemaining,
    required this.membershipExpiry,
    required this.preferences,
    required this.stats,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    MembershipType? membershipType,
    int? creditsRemaining,
    DateTime? membershipExpiry,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      membershipType: membershipType ?? this.membershipType,
      creditsRemaining: creditsRemaining ?? this.creditsRemaining,
      membershipExpiry: membershipExpiry ?? this.membershipExpiry,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profileImageUrl,
        membershipType,
        creditsRemaining,
        membershipExpiry,
        preferences,
        stats,
      ];
}

enum MembershipType {
  @JsonValue('free')
  free,
  @JsonValue('plus')
  plus,
  @JsonValue('premium_plus')
  premiumPlus,
}

@JsonSerializable()
class UserPreferences extends Equatable {
  final double playbackSpeed;
  final int skipForwardSeconds;
  final int skipBackwardSeconds;
  final bool autoPlay;
  final bool downloadOnWifi;
  final bool darkMode;
  final bool notificationsEnabled;

  const UserPreferences({
    this.playbackSpeed = 1.0,
    this.skipForwardSeconds = 30,
    this.skipBackwardSeconds = 30,
    this.autoPlay = true,
    this.downloadOnWifi = true,
    this.darkMode = false,
    this.notificationsEnabled = true,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    double? playbackSpeed,
    int? skipForwardSeconds,
    int? skipBackwardSeconds,
    bool? autoPlay,
    bool? downloadOnWifi,
    bool? darkMode,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      skipForwardSeconds: skipForwardSeconds ?? this.skipForwardSeconds,
      skipBackwardSeconds: skipBackwardSeconds ?? this.skipBackwardSeconds,
      autoPlay: autoPlay ?? this.autoPlay,
      downloadOnWifi: downloadOnWifi ?? this.downloadOnWifi,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        playbackSpeed,
        skipForwardSeconds,
        skipBackwardSeconds,
        autoPlay,
        downloadOnWifi,
        darkMode,
        notificationsEnabled,
      ];
}

@JsonSerializable()
class UserStats extends Equatable {
  final Duration totalListeningTime;
  final int booksCompleted;
  final int podcastsListened;
  final List<String> badges;
  final int currentStreak;
  final int longestStreak;

  const UserStats({
    required this.totalListeningTime,
    required this.booksCompleted,
    required this.podcastsListened,
    required this.badges,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  UserStats copyWith({
    Duration? totalListeningTime,
    int? booksCompleted,
    int? podcastsListened,
    List<String>? badges,
    int? currentStreak,
    int? longestStreak,
  }) {
    return UserStats(
      totalListeningTime: totalListeningTime ?? this.totalListeningTime,
      booksCompleted: booksCompleted ?? this.booksCompleted,
      podcastsListened: podcastsListened ?? this.podcastsListened,
      badges: badges ?? this.badges,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }

  @override
  List<Object?> get props => [
        totalListeningTime,
        booksCompleted,
        podcastsListened,
        badges,
        currentStreak,
        longestStreak,
      ];
}