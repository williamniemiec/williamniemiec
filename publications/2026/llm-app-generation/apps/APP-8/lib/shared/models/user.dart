class User {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final int totalXP;
  final int currentStreak;
  final int longestStreak;
  final int gems;
  final int hearts;
  final int maxHearts;
  final String currentLanguage;
  final List<String> learningLanguages;
  final String currentLeague;
  final int leagueRank;
  final List<String> achievements;
  final List<String> friends;
  final DateTime lastActiveDate;
  final DateTime joinDate;
  final bool isPremium;
  final int dailyXPGoal;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    this.totalXP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.gems = 500,
    this.hearts = 5,
    this.maxHearts = 5,
    this.currentLanguage = 'Spanish',
    this.learningLanguages = const ['Spanish'],
    this.currentLeague = 'Bronze',
    this.leagueRank = 0,
    this.achievements = const [],
    this.friends = const [],
    required this.lastActiveDate,
    required this.joinDate,
    this.isPremium = false,
    this.dailyXPGoal = 20,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    int? gems,
    int? hearts,
    int? maxHearts,
    String? currentLanguage,
    List<String>? learningLanguages,
    String? currentLeague,
    int? leagueRank,
    List<String>? achievements,
    List<String>? friends,
    DateTime? lastActiveDate,
    DateTime? joinDate,
    bool? isPremium,
    int? dailyXPGoal,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      totalXP: totalXP ?? this.totalXP,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      gems: gems ?? this.gems,
      hearts: hearts ?? this.hearts,
      maxHearts: maxHearts ?? this.maxHearts,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      learningLanguages: learningLanguages ?? this.learningLanguages,
      currentLeague: currentLeague ?? this.currentLeague,
      leagueRank: leagueRank ?? this.leagueRank,
      achievements: achievements ?? this.achievements,
      friends: friends ?? this.friends,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      joinDate: joinDate ?? this.joinDate,
      isPremium: isPremium ?? this.isPremium,
      dailyXPGoal: dailyXPGoal ?? this.dailyXPGoal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'totalXP': totalXP,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'gems': gems,
      'hearts': hearts,
      'maxHearts': maxHearts,
      'currentLanguage': currentLanguage,
      'learningLanguages': learningLanguages,
      'currentLeague': currentLeague,
      'leagueRank': leagueRank,
      'achievements': achievements,
      'friends': friends,
      'lastActiveDate': lastActiveDate.toIso8601String(),
      'joinDate': joinDate.toIso8601String(),
      'isPremium': isPremium,
      'dailyXPGoal': dailyXPGoal,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      totalXP: json['totalXP'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      gems: json['gems'] ?? 500,
      hearts: json['hearts'] ?? 5,
      maxHearts: json['maxHearts'] ?? 5,
      currentLanguage: json['currentLanguage'] ?? 'Spanish',
      learningLanguages: List<String>.from(json['learningLanguages'] ?? ['Spanish']),
      currentLeague: json['currentLeague'] ?? 'Bronze',
      leagueRank: json['leagueRank'] ?? 0,
      achievements: List<String>.from(json['achievements'] ?? []),
      friends: List<String>.from(json['friends'] ?? []),
      lastActiveDate: DateTime.parse(json['lastActiveDate']),
      joinDate: DateTime.parse(json['joinDate']),
      isPremium: json['isPremium'] ?? false,
      dailyXPGoal: json['dailyXPGoal'] ?? 20,
    );
  }
}