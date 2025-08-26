import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String? displayName;

  @HiveField(4)
  final String? profileImageUrl;

  @HiveField(5)
  final int coinBalance;

  @HiveField(6)
  final bool isPremiumSubscriber;

  @HiveField(7)
  final DateTime? subscriptionExpiryDate;

  @HiveField(8)
  final String subscriptionType; // 'none', 'weekly', 'monthly', 'yearly'

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime lastLoginAt;

  @HiveField(11)
  final List<String> watchedEpisodes; // Episode IDs

  @HiveField(12)
  final List<String> favoritesDramas; // Drama IDs

  @HiveField(13)
  final List<String> watchLaterDramas; // Drama IDs

  @HiveField(14)
  final Map<String, int> dramaProgress; // Drama ID -> Last watched episode number

  @HiveField(15)
  final String preferredLanguage;

  @HiveField(16)
  final List<String> preferredGenres;

  @HiveField(17)
  final bool notificationsEnabled;

  @HiveField(18)
  final bool autoPlayEnabled;

  @HiveField(19)
  final String videoQuality; // 'auto', 'low', 'medium', 'high'

  @HiveField(20)
  final int dailyCheckInStreak;

  @HiveField(21)
  final DateTime? lastCheckInDate;

  @HiveField(22)
  final int totalWatchTime; // Total watch time in minutes

  @HiveField(23)
  final int totalEpisodesWatched;

  @HiveField(24)
  final Map<String, dynamic> settings; // Additional user settings

  User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.profileImageUrl,
    required this.coinBalance,
    required this.isPremiumSubscriber,
    this.subscriptionExpiryDate,
    required this.subscriptionType,
    required this.createdAt,
    required this.lastLoginAt,
    required this.watchedEpisodes,
    required this.favoritesDramas,
    required this.watchLaterDramas,
    required this.dramaProgress,
    required this.preferredLanguage,
    required this.preferredGenres,
    required this.notificationsEnabled,
    required this.autoPlayEnabled,
    required this.videoQuality,
    required this.dailyCheckInStreak,
    this.lastCheckInDate,
    required this.totalWatchTime,
    required this.totalEpisodesWatched,
    required this.settings,
  });

  // Factory constructor for creating User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      coinBalance: json['coinBalance'] as int,
      isPremiumSubscriber: json['isPremiumSubscriber'] as bool,
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'] as String)
          : null,
      subscriptionType: json['subscriptionType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      watchedEpisodes: List<String>.from(json['watchedEpisodes'] as List),
      favoritesDramas: List<String>.from(json['favoritesDramas'] as List),
      watchLaterDramas: List<String>.from(json['watchLaterDramas'] as List),
      dramaProgress: Map<String, int>.from(json['dramaProgress'] as Map),
      preferredLanguage: json['preferredLanguage'] as String,
      preferredGenres: List<String>.from(json['preferredGenres'] as List),
      notificationsEnabled: json['notificationsEnabled'] as bool,
      autoPlayEnabled: json['autoPlayEnabled'] as bool,
      videoQuality: json['videoQuality'] as String,
      dailyCheckInStreak: json['dailyCheckInStreak'] as int,
      lastCheckInDate: json['lastCheckInDate'] != null
          ? DateTime.parse(json['lastCheckInDate'] as String)
          : null,
      totalWatchTime: json['totalWatchTime'] as int,
      totalEpisodesWatched: json['totalEpisodesWatched'] as int,
      settings: Map<String, dynamic>.from(json['settings'] as Map),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'coinBalance': coinBalance,
      'isPremiumSubscriber': isPremiumSubscriber,
      'subscriptionExpiryDate': subscriptionExpiryDate?.toIso8601String(),
      'subscriptionType': subscriptionType,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'watchedEpisodes': watchedEpisodes,
      'favoritesDramas': favoritesDramas,
      'watchLaterDramas': watchLaterDramas,
      'dramaProgress': dramaProgress,
      'preferredLanguage': preferredLanguage,
      'preferredGenres': preferredGenres,
      'notificationsEnabled': notificationsEnabled,
      'autoPlayEnabled': autoPlayEnabled,
      'videoQuality': videoQuality,
      'dailyCheckInStreak': dailyCheckInStreak,
      'lastCheckInDate': lastCheckInDate?.toIso8601String(),
      'totalWatchTime': totalWatchTime,
      'totalEpisodesWatched': totalEpisodesWatched,
      'settings': settings,
    };
  }

  // Helper methods
  String get displayNameOrUsername => displayName ?? username;

  bool get hasActiveSubscription {
    if (!isPremiumSubscriber) return false;
    if (subscriptionExpiryDate == null) return false;
    return subscriptionExpiryDate!.isAfter(DateTime.now());
  }

  bool get canWatchPremiumContent => hasActiveSubscription;

  int get daysUntilSubscriptionExpiry {
    if (subscriptionExpiryDate == null) return 0;
    return subscriptionExpiryDate!.difference(DateTime.now()).inDays;
  }

  bool get canCheckInToday {
    if (lastCheckInDate == null) return true;
    final today = DateTime.now();
    final lastCheckIn = lastCheckInDate!;
    return !isSameDay(today, lastCheckIn);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Check if user has watched a specific episode
  bool hasWatchedEpisode(String episodeId) {
    return watchedEpisodes.contains(episodeId);
  }

  // Check if drama is in favorites
  bool isDramaFavorite(String dramaId) {
    return favoritesDramas.contains(dramaId);
  }

  // Check if drama is in watch later list
  bool isDramaInWatchLater(String dramaId) {
    return watchLaterDramas.contains(dramaId);
  }

  // Get progress for a specific drama
  int getDramaProgress(String dramaId) {
    return dramaProgress[dramaId] ?? 0;
  }

  // Get formatted total watch time
  String get formattedTotalWatchTime {
    final hours = totalWatchTime ~/ 60;
    final minutes = totalWatchTime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  // Copy with method for updating user
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? profileImageUrl,
    int? coinBalance,
    bool? isPremiumSubscriber,
    DateTime? subscriptionExpiryDate,
    String? subscriptionType,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? watchedEpisodes,
    List<String>? favoritesDramas,
    List<String>? watchLaterDramas,
    Map<String, int>? dramaProgress,
    String? preferredLanguage,
    List<String>? preferredGenres,
    bool? notificationsEnabled,
    bool? autoPlayEnabled,
    String? videoQuality,
    int? dailyCheckInStreak,
    DateTime? lastCheckInDate,
    int? totalWatchTime,
    int? totalEpisodesWatched,
    Map<String, dynamic>? settings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coinBalance: coinBalance ?? this.coinBalance,
      isPremiumSubscriber: isPremiumSubscriber ?? this.isPremiumSubscriber,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      watchedEpisodes: watchedEpisodes ?? this.watchedEpisodes,
      favoritesDramas: favoritesDramas ?? this.favoritesDramas,
      watchLaterDramas: watchLaterDramas ?? this.watchLaterDramas,
      dramaProgress: dramaProgress ?? this.dramaProgress,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredGenres: preferredGenres ?? this.preferredGenres,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoPlayEnabled: autoPlayEnabled ?? this.autoPlayEnabled,
      videoQuality: videoQuality ?? this.videoQuality,
      dailyCheckInStreak: dailyCheckInStreak ?? this.dailyCheckInStreak,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      totalWatchTime: totalWatchTime ?? this.totalWatchTime,
      totalEpisodesWatched: totalEpisodesWatched ?? this.totalEpisodesWatched,
      settings: settings ?? this.settings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, username: $username, coinBalance: $coinBalance)';
  }
}