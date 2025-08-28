import 'user.dart';

class League {
  final String id;
  final String name;
  final String sport;
  final String season;
  final String leagueType; // redraft, keeper, dynasty
  final String status; // pre_draft, drafting, in_season, complete
  final int totalRosters;
  final LeagueSettings settings;
  final String? avatar;
  final DateTime createdAt;
  final String creatorId;
  final List<LeagueRoster> rosters;
  final DraftInfo? draftInfo;
  final List<String> memberIds;
  final Map<String, dynamic> metadata;

  const League({
    required this.id,
    required this.name,
    required this.sport,
    required this.season,
    required this.leagueType,
    required this.status,
    required this.totalRosters,
    required this.settings,
    this.avatar,
    required this.createdAt,
    required this.creatorId,
    this.rosters = const [],
    this.draftInfo,
    this.memberIds = const [],
    this.metadata = const {},
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['league_id'] as String,
      name: json['name'] as String,
      sport: json['sport'] as String,
      season: json['season'] as String,
      leagueType: json['league_type'] as String,
      status: json['status'] as String,
      totalRosters: json['total_rosters'] as int,
      settings: LeagueSettings.fromJson(json['settings'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['created'] as String),
      creatorId: json['creator'] as String,
      rosters: (json['rosters'] as List<dynamic>?)
          ?.map((r) => LeagueRoster.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
      draftInfo: json['draft_info'] != null 
          ? DraftInfo.fromJson(json['draft_info'] as Map<String, dynamic>)
          : null,
      memberIds: List<String>.from(json['members'] ?? []),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league_id': id,
      'name': name,
      'sport': sport,
      'season': season,
      'league_type': leagueType,
      'status': status,
      'total_rosters': totalRosters,
      'settings': settings.toJson(),
      'avatar': avatar,
      'created': createdAt.toIso8601String(),
      'creator': creatorId,
      'rosters': rosters.map((r) => r.toJson()).toList(),
      'draft_info': draftInfo?.toJson(),
      'members': memberIds,
      'metadata': metadata,
    };
  }

  bool get isDrafting => status == 'drafting';
  bool get isInSeason => status == 'in_season';
  bool get isComplete => status == 'complete';
  bool get isPreDraft => status == 'pre_draft';
}

class LeagueSettings {
  final int rosterSize;
  final Map<String, int> rosterPositions;
  final String scoringType;
  final Map<String, double> scoringSettings;
  final String waiverType;
  final int waiverBudget;
  final int playoffWeeks;
  final int playoffTeams;
  final bool tradeDeadline;
  final int maxKeepers;
  final Map<String, dynamic> customSettings;

  const LeagueSettings({
    required this.rosterSize,
    required this.rosterPositions,
    required this.scoringType,
    required this.scoringSettings,
    required this.waiverType,
    this.waiverBudget = 100,
    this.playoffWeeks = 3,
    this.playoffTeams = 4,
    this.tradeDeadline = true,
    this.maxKeepers = 0,
    this.customSettings = const {},
  });

  factory LeagueSettings.fromJson(Map<String, dynamic> json) {
    return LeagueSettings(
      rosterSize: json['roster_size'] as int,
      rosterPositions: Map<String, int>.from(json['roster_positions'] ?? {}),
      scoringType: json['scoring_type'] as String,
      scoringSettings: Map<String, double>.from(
        (json['scoring_settings'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      waiverType: json['waiver_type'] as String,
      waiverBudget: json['waiver_budget'] as int? ?? 100,
      playoffWeeks: json['playoff_weeks'] as int? ?? 3,
      playoffTeams: json['playoff_teams'] as int? ?? 4,
      tradeDeadline: json['trade_deadline'] as bool? ?? true,
      maxKeepers: json['max_keepers'] as int? ?? 0,
      customSettings: json['custom_settings'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roster_size': rosterSize,
      'roster_positions': rosterPositions,
      'scoring_type': scoringType,
      'scoring_settings': scoringSettings,
      'waiver_type': waiverType,
      'waiver_budget': waiverBudget,
      'playoff_weeks': playoffWeeks,
      'playoff_teams': playoffTeams,
      'trade_deadline': tradeDeadline,
      'max_keepers': maxKeepers,
      'custom_settings': customSettings,
    };
  }
}

class LeagueRoster {
  final String rosterId;
  final String ownerId;
  final List<String> players;
  final List<String> starters;
  final List<String> bench;
  final List<String> taxi;
  final List<String> reserve;
  final Map<String, dynamic> settings;
  final RosterStats stats;

  const LeagueRoster({
    required this.rosterId,
    required this.ownerId,
    this.players = const [],
    this.starters = const [],
    this.bench = const [],
    this.taxi = const [],
    this.reserve = const [],
    this.settings = const {},
    required this.stats,
  });

  factory LeagueRoster.fromJson(Map<String, dynamic> json) {
    return LeagueRoster(
      rosterId: json['roster_id'].toString(),
      ownerId: json['owner_id'] as String,
      players: List<String>.from(json['players'] ?? []),
      starters: List<String>.from(json['starters'] ?? []),
      bench: List<String>.from(json['bench'] ?? []),
      taxi: List<String>.from(json['taxi'] ?? []),
      reserve: List<String>.from(json['reserve'] ?? []),
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      stats: RosterStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roster_id': rosterId,
      'owner_id': ownerId,
      'players': players,
      'starters': starters,
      'bench': bench,
      'taxi': taxi,
      'reserve': reserve,
      'settings': settings,
      'stats': stats.toJson(),
    };
  }
}

class RosterStats {
  final int wins;
  final int losses;
  final int ties;
  final double pointsFor;
  final double pointsAgainst;
  final int rank;
  final int playoffSeed;

  const RosterStats({
    this.wins = 0,
    this.losses = 0,
    this.ties = 0,
    this.pointsFor = 0.0,
    this.pointsAgainst = 0.0,
    this.rank = 0,
    this.playoffSeed = 0,
  });

  factory RosterStats.fromJson(Map<String, dynamic> json) {
    return RosterStats(
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      ties: json['ties'] as int? ?? 0,
      pointsFor: (json['fpts'] as num?)?.toDouble() ?? 0.0,
      pointsAgainst: (json['fpts_against'] as num?)?.toDouble() ?? 0.0,
      rank: json['rank'] as int? ?? 0,
      playoffSeed: json['playoff_seed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wins': wins,
      'losses': losses,
      'ties': ties,
      'fpts': pointsFor,
      'fpts_against': pointsAgainst,
      'rank': rank,
      'playoff_seed': playoffSeed,
    };
  }

  double get winPercentage {
    final totalGames = wins + losses + ties;
    if (totalGames == 0) return 0.0;
    return (wins + (ties * 0.5)) / totalGames;
  }
}

class DraftInfo {
  final String draftId;
  final String type; // snake, linear, auction
  final String status; // pre_draft, drafting, complete
  final DateTime? startTime;
  final int rounds;
  final int pickTimer;
  final List<DraftPick> picks;
  final Map<String, dynamic> settings;

  const DraftInfo({
    required this.draftId,
    required this.type,
    required this.status,
    this.startTime,
    required this.rounds,
    this.pickTimer = 90,
    this.picks = const [],
    this.settings = const {},
  });

  factory DraftInfo.fromJson(Map<String, dynamic> json) {
    return DraftInfo(
      draftId: json['draft_id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      startTime: json['start_time'] != null 
          ? DateTime.parse(json['start_time'] as String)
          : null,
      rounds: json['rounds'] as int,
      pickTimer: json['pick_timer'] as int? ?? 90,
      picks: (json['picks'] as List<dynamic>?)
          ?.map((p) => DraftPick.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
      settings: json['settings'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'draft_id': draftId,
      'type': type,
      'status': status,
      'start_time': startTime?.toIso8601String(),
      'rounds': rounds,
      'pick_timer': pickTimer,
      'picks': picks.map((p) => p.toJson()).toList(),
      'settings': settings,
    };
  }

  bool get isDrafting => status == 'drafting';
  bool get isComplete => status == 'complete';
}

class DraftPick {
  final int pickNo;
  final int round;
  final String rosterId;
  final String? playerId;
  final DateTime? pickedAt;
  final Map<String, dynamic> metadata;

  const DraftPick({
    required this.pickNo,
    required this.round,
    required this.rosterId,
    this.playerId,
    this.pickedAt,
    this.metadata = const {},
  });

  factory DraftPick.fromJson(Map<String, dynamic> json) {
    return DraftPick(
      pickNo: json['pick_no'] as int,
      round: json['round'] as int,
      rosterId: json['roster_id'].toString(),
      playerId: json['player_id'] as String?,
      pickedAt: json['picked_at'] != null 
          ? DateTime.parse(json['picked_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pick_no': pickNo,
      'round': round,
      'roster_id': rosterId,
      'player_id': playerId,
      'picked_at': pickedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isPicked => playerId != null;
}