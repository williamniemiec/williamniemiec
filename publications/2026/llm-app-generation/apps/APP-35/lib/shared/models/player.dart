class Player {
  final String id;
  final String firstName;
  final String lastName;
  final String position;
  final String team;
  final String sport;
  final int? number;
  final String? photoUrl;
  final PlayerStats stats;
  final PlayerInfo info;
  final bool isActive;
  final String status; // active, injured, suspended, etc.

  const Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.team,
    required this.sport,
    this.number,
    this.photoUrl,
    required this.stats,
    required this.info,
    this.isActive = true,
    this.status = 'active',
  });

  String get fullName => '$firstName $lastName';
  String get displayName => '$firstName $lastName';

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player_id'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      position: json['position'] as String? ?? '',
      team: json['team'] as String? ?? '',
      sport: json['sport'] as String,
      number: json['number'] as int?,
      photoUrl: json['photo_url'] as String?,
      stats: PlayerStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {}),
      info: PlayerInfo.fromJson(json['info'] as Map<String, dynamic>? ?? {}),
      isActive: json['active'] as bool? ?? true,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'position': position,
      'team': team,
      'sport': sport,
      'number': number,
      'photo_url': photoUrl,
      'stats': stats.toJson(),
      'info': info.toJson(),
      'active': isActive,
      'status': status,
    };
  }

  Player copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? position,
    String? team,
    String? sport,
    int? number,
    String? photoUrl,
    PlayerStats? stats,
    PlayerInfo? info,
    bool? isActive,
    String? status,
  }) {
    return Player(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      position: position ?? this.position,
      team: team ?? this.team,
      sport: sport ?? this.sport,
      number: number ?? this.number,
      photoUrl: photoUrl ?? this.photoUrl,
      stats: stats ?? this.stats,
      info: info ?? this.info,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }
}

class PlayerStats {
  final Map<String, double> seasonStats;
  final Map<String, double> weeklyStats;
  final double fantasyPoints;
  final double projectedPoints;
  final int gamesPlayed;
  final Map<String, dynamic> advancedStats;

  const PlayerStats({
    this.seasonStats = const {},
    this.weeklyStats = const {},
    this.fantasyPoints = 0.0,
    this.projectedPoints = 0.0,
    this.gamesPlayed = 0,
    this.advancedStats = const {},
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      seasonStats: Map<String, double>.from(
        (json['season_stats'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, (v as num?)?.toDouble() ?? 0.0)),
      ),
      weeklyStats: Map<String, double>.from(
        (json['weekly_stats'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, (v as num?)?.toDouble() ?? 0.0)),
      ),
      fantasyPoints: (json['fantasy_points'] as num?)?.toDouble() ?? 0.0,
      projectedPoints: (json['projected_points'] as num?)?.toDouble() ?? 0.0,
      gamesPlayed: json['games_played'] as int? ?? 0,
      advancedStats: json['advanced_stats'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season_stats': seasonStats,
      'weekly_stats': weeklyStats,
      'fantasy_points': fantasyPoints,
      'projected_points': projectedPoints,
      'games_played': gamesPlayed,
      'advanced_stats': advancedStats,
    };
  }
}

class PlayerInfo {
  final int? age;
  final String? height;
  final String? weight;
  final String? college;
  final int? yearsExp;
  final String? birthDate;
  final String? injuryStatus;
  final String? injuryNotes;
  final Map<String, dynamic> metadata;

  const PlayerInfo({
    this.age,
    this.height,
    this.weight,
    this.college,
    this.yearsExp,
    this.birthDate,
    this.injuryStatus,
    this.injuryNotes,
    this.metadata = const {},
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(
      age: json['age'] as int?,
      height: json['height'] as String?,
      weight: json['weight'] as String?,
      college: json['college'] as String?,
      yearsExp: json['years_exp'] as int?,
      birthDate: json['birth_date'] as String?,
      injuryStatus: json['injury_status'] as String?,
      injuryNotes: json['injury_notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'college': college,
      'years_exp': yearsExp,
      'birth_date': birthDate,
      'injury_status': injuryStatus,
      'injury_notes': injuryNotes,
      'metadata': metadata,
    };
  }

  bool get isInjured => injuryStatus != null && injuryStatus != 'healthy';
}

class PlayerNews {
  final String id;
  final String playerId;
  final String title;
  final String content;
  final String source;
  final DateTime publishedAt;
  final String category; // injury, trade, performance, etc.
  final int priority; // 1-5, 5 being highest
  final Map<String, dynamic> metadata;

  const PlayerNews({
    required this.id,
    required this.playerId,
    required this.title,
    required this.content,
    required this.source,
    required this.publishedAt,
    required this.category,
    this.priority = 1,
    this.metadata = const {},
  });

  factory PlayerNews.fromJson(Map<String, dynamic> json) {
    return PlayerNews(
      id: json['id'] as String,
      playerId: json['player_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      source: json['source'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      category: json['category'] as String,
      priority: json['priority'] as int? ?? 1,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'title': title,
      'content': content,
      'source': source,
      'published_at': publishedAt.toIso8601String(),
      'category': category,
      'priority': priority,
      'metadata': metadata,
    };
  }

  bool get isHighPriority => priority >= 4;
  bool get isInjuryNews => category == 'injury';
  bool get isTradeNews => category == 'trade';
}