class User {
  final String id;
  final String username;
  final String displayName;
  final String? avatar;
  final String email;
  final DateTime createdAt;
  final DateTime lastActive;
  final Map<String, dynamic> settings;
  final List<String> favoriteTeams;
  final UserStats stats;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatar,
    required this.email,
    required this.createdAt,
    required this.lastActive,
    this.settings = const {},
    this.favoriteTeams = const [],
    required this.stats,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      avatar: json['avatar'] as String?,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActive: DateTime.parse(json['last_active'] as String),
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      favoriteTeams: List<String>.from(json['favorite_teams'] ?? []),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'avatar': avatar,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'last_active': lastActive.toIso8601String(),
      'settings': settings,
      'favorite_teams': favoriteTeams,
      'stats': stats.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatar,
    String? email,
    DateTime? createdAt,
    DateTime? lastActive,
    Map<String, dynamic>? settings,
    List<String>? favoriteTeams,
    UserStats? stats,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      settings: settings ?? this.settings,
      favoriteTeams: favoriteTeams ?? this.favoriteTeams,
      stats: stats ?? this.stats,
    );
  }
}

class UserStats {
  final int totalLeagues;
  final int championships;
  final int totalTrades;
  final double winPercentage;
  final int totalPoints;
  final Map<String, int> sportStats;

  const UserStats({
    this.totalLeagues = 0,
    this.championships = 0,
    this.totalTrades = 0,
    this.winPercentage = 0.0,
    this.totalPoints = 0,
    this.sportStats = const {},
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalLeagues: json['total_leagues'] as int? ?? 0,
      championships: json['championships'] as int? ?? 0,
      totalTrades: json['total_trades'] as int? ?? 0,
      winPercentage: (json['win_percentage'] as num?)?.toDouble() ?? 0.0,
      totalPoints: json['total_points'] as int? ?? 0,
      sportStats: Map<String, int>.from(json['sport_stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_leagues': totalLeagues,
      'championships': championships,
      'total_trades': totalTrades,
      'win_percentage': winPercentage,
      'total_points': totalPoints,
      'sport_stats': sportStats,
    };
  }
}