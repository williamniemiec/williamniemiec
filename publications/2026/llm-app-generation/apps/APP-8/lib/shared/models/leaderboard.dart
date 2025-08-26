enum LeagueType {
  bronze,
  silver,
  gold,
  sapphire,
  ruby,
  emerald,
  amethyst,
  pearl,
  obsidian,
  diamond,
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final int weeklyXP;
  final int rank;
  final bool isCurrentUser;
  final bool isPromoted;
  final bool isDemoted;
  final LeagueType currentLeague;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    this.profileImageUrl,
    required this.weeklyXP,
    required this.rank,
    this.isCurrentUser = false,
    this.isPromoted = false,
    this.isDemoted = false,
    required this.currentLeague,
  });

  LeaderboardEntry copyWith({
    String? userId,
    String? username,
    String? profileImageUrl,
    int? weeklyXP,
    int? rank,
    bool? isCurrentUser,
    bool? isPromoted,
    bool? isDemoted,
    LeagueType? currentLeague,
  }) {
    return LeaderboardEntry(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      weeklyXP: weeklyXP ?? this.weeklyXP,
      rank: rank ?? this.rank,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isPromoted: isPromoted ?? this.isPromoted,
      isDemoted: isDemoted ?? this.isDemoted,
      currentLeague: currentLeague ?? this.currentLeague,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'weeklyXP': weeklyXP,
      'rank': rank,
      'isCurrentUser': isCurrentUser,
      'isPromoted': isPromoted,
      'isDemoted': isDemoted,
      'currentLeague': currentLeague.name,
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'],
      weeklyXP: json['weeklyXP'],
      rank: json['rank'],
      isCurrentUser: json['isCurrentUser'] ?? false,
      isPromoted: json['isPromoted'] ?? false,
      isDemoted: json['isDemoted'] ?? false,
      currentLeague: LeagueType.values.firstWhere(
        (e) => e.name == json['currentLeague'],
      ),
    );
  }
}

class Leaderboard {
  final LeagueType league;
  final List<LeaderboardEntry> entries;
  final DateTime weekStart;
  final DateTime weekEnd;
  final int promotionThreshold;
  final int demotionThreshold;
  final String currentUserId;

  const Leaderboard({
    required this.league,
    required this.entries,
    required this.weekStart,
    required this.weekEnd,
    this.promotionThreshold = 10,
    this.demotionThreshold = 5,
    required this.currentUserId,
  });

  LeaderboardEntry? get currentUserEntry {
    try {
      return entries.firstWhere((entry) => entry.userId == currentUserId);
    } catch (e) {
      return null;
    }
  }

  List<LeaderboardEntry> get promotionZone {
    return entries.take(promotionThreshold).toList();
  }

  List<LeaderboardEntry> get demotionZone {
    final totalEntries = entries.length;
    final demotionStart = totalEntries - demotionThreshold;
    return entries.skip(demotionStart).toList();
  }

  List<LeaderboardEntry> get safeZone {
    final totalEntries = entries.length;
    final safeStart = promotionThreshold;
    final safeEnd = totalEntries - demotionThreshold;
    return entries.skip(safeStart).take(safeEnd - safeStart).toList();
  }

  Duration get timeRemaining {
    final now = DateTime.now();
    return weekEnd.difference(now);
  }

  Leaderboard copyWith({
    LeagueType? league,
    List<LeaderboardEntry>? entries,
    DateTime? weekStart,
    DateTime? weekEnd,
    int? promotionThreshold,
    int? demotionThreshold,
    String? currentUserId,
  }) {
    return Leaderboard(
      league: league ?? this.league,
      entries: entries ?? this.entries,
      weekStart: weekStart ?? this.weekStart,
      weekEnd: weekEnd ?? this.weekEnd,
      promotionThreshold: promotionThreshold ?? this.promotionThreshold,
      demotionThreshold: demotionThreshold ?? this.demotionThreshold,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league': league.name,
      'entries': entries.map((e) => e.toJson()).toList(),
      'weekStart': weekStart.toIso8601String(),
      'weekEnd': weekEnd.toIso8601String(),
      'promotionThreshold': promotionThreshold,
      'demotionThreshold': demotionThreshold,
      'currentUserId': currentUserId,
    };
  }

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      league: LeagueType.values.firstWhere((e) => e.name == json['league']),
      entries: (json['entries'] as List)
          .map((e) => LeaderboardEntry.fromJson(e))
          .toList(),
      weekStart: DateTime.parse(json['weekStart']),
      weekEnd: DateTime.parse(json['weekEnd']),
      promotionThreshold: json['promotionThreshold'] ?? 10,
      demotionThreshold: json['demotionThreshold'] ?? 5,
      currentUserId: json['currentUserId'],
    );
  }
}