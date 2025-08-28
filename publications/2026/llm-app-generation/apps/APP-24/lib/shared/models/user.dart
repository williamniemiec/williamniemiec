import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final UserPreferences preferences;
  final UserStats stats;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    required this.preferences,
    required this.stats,
    required this.createdAt,
    required this.lastActiveAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    UserPreferences? preferences,
    UserStats? stats,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        profileImageUrl,
        preferences,
        stats,
        createdAt,
        lastActiveAt,
      ];
}

class UserPreferences extends Equatable {
  final bool voiceNavigationEnabled;
  final String voiceLanguage;
  final double voiceVolume;
  final bool speedAlertsEnabled;
  final bool policeAlertsEnabled;
  final bool accidentAlertsEnabled;
  final bool trafficAlertsEnabled;
  final bool hazardAlertsEnabled;
  final bool avoidTolls;
  final bool avoidHighways;
  final bool avoidFerries;
  final String mapDisplayMode; // '2d', '3d'
  final String routingPreference; // 'fastest', 'shortest', 'eco'
  final bool darkModeEnabled;
  final String carIcon;
  final String mood;

  const UserPreferences({
    this.voiceNavigationEnabled = true,
    this.voiceLanguage = 'en-US',
    this.voiceVolume = 0.8,
    this.speedAlertsEnabled = true,
    this.policeAlertsEnabled = true,
    this.accidentAlertsEnabled = true,
    this.trafficAlertsEnabled = true,
    this.hazardAlertsEnabled = true,
    this.avoidTolls = false,
    this.avoidHighways = false,
    this.avoidFerries = false,
    this.mapDisplayMode = '2d',
    this.routingPreference = 'fastest',
    this.darkModeEnabled = false,
    this.carIcon = 'default',
    this.mood = 'happy',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      voiceNavigationEnabled: json['voiceNavigationEnabled'] as bool? ?? true,
      voiceLanguage: json['voiceLanguage'] as String? ?? 'en-US',
      voiceVolume: (json['voiceVolume'] as num?)?.toDouble() ?? 0.8,
      speedAlertsEnabled: json['speedAlertsEnabled'] as bool? ?? true,
      policeAlertsEnabled: json['policeAlertsEnabled'] as bool? ?? true,
      accidentAlertsEnabled: json['accidentAlertsEnabled'] as bool? ?? true,
      trafficAlertsEnabled: json['trafficAlertsEnabled'] as bool? ?? true,
      hazardAlertsEnabled: json['hazardAlertsEnabled'] as bool? ?? true,
      avoidTolls: json['avoidTolls'] as bool? ?? false,
      avoidHighways: json['avoidHighways'] as bool? ?? false,
      avoidFerries: json['avoidFerries'] as bool? ?? false,
      mapDisplayMode: json['mapDisplayMode'] as String? ?? '2d',
      routingPreference: json['routingPreference'] as String? ?? 'fastest',
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
      carIcon: json['carIcon'] as String? ?? 'default',
      mood: json['mood'] as String? ?? 'happy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voiceNavigationEnabled': voiceNavigationEnabled,
      'voiceLanguage': voiceLanguage,
      'voiceVolume': voiceVolume,
      'speedAlertsEnabled': speedAlertsEnabled,
      'policeAlertsEnabled': policeAlertsEnabled,
      'accidentAlertsEnabled': accidentAlertsEnabled,
      'trafficAlertsEnabled': trafficAlertsEnabled,
      'hazardAlertsEnabled': hazardAlertsEnabled,
      'avoidTolls': avoidTolls,
      'avoidHighways': avoidHighways,
      'avoidFerries': avoidFerries,
      'mapDisplayMode': mapDisplayMode,
      'routingPreference': routingPreference,
      'darkModeEnabled': darkModeEnabled,
      'carIcon': carIcon,
      'mood': mood,
    };
  }

  UserPreferences copyWith({
    bool? voiceNavigationEnabled,
    String? voiceLanguage,
    double? voiceVolume,
    bool? speedAlertsEnabled,
    bool? policeAlertsEnabled,
    bool? accidentAlertsEnabled,
    bool? trafficAlertsEnabled,
    bool? hazardAlertsEnabled,
    bool? avoidTolls,
    bool? avoidHighways,
    bool? avoidFerries,
    String? mapDisplayMode,
    String? routingPreference,
    bool? darkModeEnabled,
    String? carIcon,
    String? mood,
  }) {
    return UserPreferences(
      voiceNavigationEnabled: voiceNavigationEnabled ?? this.voiceNavigationEnabled,
      voiceLanguage: voiceLanguage ?? this.voiceLanguage,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      speedAlertsEnabled: speedAlertsEnabled ?? this.speedAlertsEnabled,
      policeAlertsEnabled: policeAlertsEnabled ?? this.policeAlertsEnabled,
      accidentAlertsEnabled: accidentAlertsEnabled ?? this.accidentAlertsEnabled,
      trafficAlertsEnabled: trafficAlertsEnabled ?? this.trafficAlertsEnabled,
      hazardAlertsEnabled: hazardAlertsEnabled ?? this.hazardAlertsEnabled,
      avoidTolls: avoidTolls ?? this.avoidTolls,
      avoidHighways: avoidHighways ?? this.avoidHighways,
      avoidFerries: avoidFerries ?? this.avoidFerries,
      mapDisplayMode: mapDisplayMode ?? this.mapDisplayMode,
      routingPreference: routingPreference ?? this.routingPreference,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      carIcon: carIcon ?? this.carIcon,
      mood: mood ?? this.mood,
    );
  }

  @override
  List<Object?> get props => [
        voiceNavigationEnabled,
        voiceLanguage,
        voiceVolume,
        speedAlertsEnabled,
        policeAlertsEnabled,
        accidentAlertsEnabled,
        trafficAlertsEnabled,
        hazardAlertsEnabled,
        avoidTolls,
        avoidHighways,
        avoidFerries,
        mapDisplayMode,
        routingPreference,
        darkModeEnabled,
        carIcon,
        mood,
      ];
}

class UserStats extends Equatable {
  final int totalDrives;
  final double totalDistance; // in kilometers
  final int totalDrivingTime; // in minutes
  final int reportsSubmitted;
  final int thanksReceived;
  final int level;
  final int points;

  const UserStats({
    this.totalDrives = 0,
    this.totalDistance = 0.0,
    this.totalDrivingTime = 0,
    this.reportsSubmitted = 0,
    this.thanksReceived = 0,
    this.level = 1,
    this.points = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalDrives: json['totalDrives'] as int? ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      totalDrivingTime: json['totalDrivingTime'] as int? ?? 0,
      reportsSubmitted: json['reportsSubmitted'] as int? ?? 0,
      thanksReceived: json['thanksReceived'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDrives': totalDrives,
      'totalDistance': totalDistance,
      'totalDrivingTime': totalDrivingTime,
      'reportsSubmitted': reportsSubmitted,
      'thanksReceived': thanksReceived,
      'level': level,
      'points': points,
    };
  }

  UserStats copyWith({
    int? totalDrives,
    double? totalDistance,
    int? totalDrivingTime,
    int? reportsSubmitted,
    int? thanksReceived,
    int? level,
    int? points,
  }) {
    return UserStats(
      totalDrives: totalDrives ?? this.totalDrives,
      totalDistance: totalDistance ?? this.totalDistance,
      totalDrivingTime: totalDrivingTime ?? this.totalDrivingTime,
      reportsSubmitted: reportsSubmitted ?? this.reportsSubmitted,
      thanksReceived: thanksReceived ?? this.thanksReceived,
      level: level ?? this.level,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [
        totalDrives,
        totalDistance,
        totalDrivingTime,
        reportsSubmitted,
        thanksReceived,
        level,
        points,
      ];
}