class Sport {
  final String id;
  final String name;
  final String displayName;
  final String iconUrl;
  final bool isPopular;
  final bool isLive;
  final int eventCount;
  final int liveEventCount;
  final List<League> leagues;

  const Sport({
    required this.id,
    required this.name,
    required this.displayName,
    required this.iconUrl,
    required this.isPopular,
    required this.isLive,
    required this.eventCount,
    required this.liveEventCount,
    required this.leagues,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      iconUrl: json['icon_url'] as String,
      isPopular: json['is_popular'] as bool,
      isLive: json['is_live'] as bool,
      eventCount: json['event_count'] as int,
      liveEventCount: json['live_event_count'] as int,
      leagues: (json['leagues'] as List)
          .map((e) => League.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'icon_url': iconUrl,
      'is_popular': isPopular,
      'is_live': isLive,
      'event_count': eventCount,
      'live_event_count': liveEventCount,
      'leagues': leagues.map((e) => e.toJson()).toList(),
    };
  }

  Sport copyWith({
    String? id,
    String? name,
    String? displayName,
    String? iconUrl,
    bool? isPopular,
    bool? isLive,
    int? eventCount,
    int? liveEventCount,
    List<League>? leagues,
  }) {
    return Sport(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      iconUrl: iconUrl ?? this.iconUrl,
      isPopular: isPopular ?? this.isPopular,
      isLive: isLive ?? this.isLive,
      eventCount: eventCount ?? this.eventCount,
      liveEventCount: liveEventCount ?? this.liveEventCount,
      leagues: leagues ?? this.leagues,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sport && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Sport(id: $id, name: $name, eventCount: $eventCount)';
  }
}

class League {
  final String id;
  final String name;
  final String displayName;
  final String country;
  final String countryCode;
  final String? logoUrl;
  final bool isPopular;
  final bool isLive;
  final int eventCount;
  final int liveEventCount;
  final List<SportEvent> events;

  const League({
    required this.id,
    required this.name,
    required this.displayName,
    required this.country,
    required this.countryCode,
    this.logoUrl,
    required this.isPopular,
    required this.isLive,
    required this.eventCount,
    required this.liveEventCount,
    required this.events,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      country: json['country'] as String,
      countryCode: json['country_code'] as String,
      logoUrl: json['logo_url'] as String?,
      isPopular: json['is_popular'] as bool,
      isLive: json['is_live'] as bool,
      eventCount: json['event_count'] as int,
      liveEventCount: json['live_event_count'] as int,
      events: (json['events'] as List)
          .map((e) => SportEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'country': country,
      'country_code': countryCode,
      'logo_url': logoUrl,
      'is_popular': isPopular,
      'is_live': isLive,
      'event_count': eventCount,
      'live_event_count': liveEventCount,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  League copyWith({
    String? id,
    String? name,
    String? displayName,
    String? country,
    String? countryCode,
    String? logoUrl,
    bool? isPopular,
    bool? isLive,
    int? eventCount,
    int? liveEventCount,
    List<SportEvent>? events,
  }) {
    return League(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      logoUrl: logoUrl ?? this.logoUrl,
      isPopular: isPopular ?? this.isPopular,
      isLive: isLive ?? this.isLive,
      eventCount: eventCount ?? this.eventCount,
      liveEventCount: liveEventCount ?? this.liveEventCount,
      events: events ?? this.events,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is League && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum EventStatus { scheduled, live, finished, postponed, cancelled, suspended }

class SportEvent {
  final String id;
  final String name;
  final String homeTeam;
  final String awayTeam;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final DateTime startTime;
  final EventStatus status;
  final bool isLive;
  final bool hasLiveStream;
  final LiveScore? liveScore;
  final List<Market> markets;
  final Map<String, dynamic>? metadata;

  const SportEvent({
    required this.id,
    required this.name,
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamLogo,
    this.awayTeamLogo,
    required this.startTime,
    required this.status,
    required this.isLive,
    required this.hasLiveStream,
    this.liveScore,
    required this.markets,
    this.metadata,
  });

  factory SportEvent.fromJson(Map<String, dynamic> json) {
    return SportEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      homeTeam: json['home_team'] as String,
      awayTeam: json['away_team'] as String,
      homeTeamLogo: json['home_team_logo'] as String?,
      awayTeamLogo: json['away_team_logo'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.scheduled,
      ),
      isLive: json['is_live'] as bool,
      hasLiveStream: json['has_live_stream'] as bool,
      liveScore: json['live_score'] != null
          ? LiveScore.fromJson(json['live_score'] as Map<String, dynamic>)
          : null,
      markets: (json['markets'] as List)
          .map((e) => Market.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_team_logo': homeTeamLogo,
      'away_team_logo': awayTeamLogo,
      'start_time': startTime.toIso8601String(),
      'status': status.name,
      'is_live': isLive,
      'has_live_stream': hasLiveStream,
      'live_score': liveScore?.toJson(),
      'markets': markets.map((e) => e.toJson()).toList(),
      'metadata': metadata,
    };
  }

  SportEvent copyWith({
    String? id,
    String? name,
    String? homeTeam,
    String? awayTeam,
    String? homeTeamLogo,
    String? awayTeamLogo,
    DateTime? startTime,
    EventStatus? status,
    bool? isLive,
    bool? hasLiveStream,
    LiveScore? liveScore,
    List<Market>? markets,
    Map<String, dynamic>? metadata,
  }) {
    return SportEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeTeamLogo: homeTeamLogo ?? this.homeTeamLogo,
      awayTeamLogo: awayTeamLogo ?? this.awayTeamLogo,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      isLive: isLive ?? this.isLive,
      hasLiveStream: hasLiveStream ?? this.hasLiveStream,
      liveScore: liveScore ?? this.liveScore,
      markets: markets ?? this.markets,
      metadata: metadata ?? this.metadata,
    );
  }

  String get displayName => '$homeTeam vs $awayTeam';
  
  bool get isFinished => status == EventStatus.finished;
  bool get isScheduled => status == EventStatus.scheduled;
  bool get isPostponed => status == EventStatus.postponed;
  bool get isCancelled => status == EventStatus.cancelled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SportEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class LiveScore {
  final int homeScore;
  final int awayScore;
  final String? period;
  final String? minute;
  final Map<String, dynamic>? additionalInfo;

  const LiveScore({
    required this.homeScore,
    required this.awayScore,
    this.period,
    this.minute,
    this.additionalInfo,
  });

  factory LiveScore.fromJson(Map<String, dynamic> json) {
    return LiveScore(
      homeScore: json['home_score'] as int,
      awayScore: json['away_score'] as int,
      period: json['period'] as String?,
      minute: json['minute'] as String?,
      additionalInfo: json['additional_info'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home_score': homeScore,
      'away_score': awayScore,
      'period': period,
      'minute': minute,
      'additional_info': additionalInfo,
    };
  }

  LiveScore copyWith({
    int? homeScore,
    int? awayScore,
    String? period,
    String? minute,
    Map<String, dynamic>? additionalInfo,
  }) {
    return LiveScore(
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      period: period ?? this.period,
      minute: minute ?? this.minute,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  String get displayScore => '$homeScore - $awayScore';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiveScore && 
           other.homeScore == homeScore && 
           other.awayScore == awayScore;
  }

  @override
  int get hashCode => Object.hash(homeScore, awayScore);
}

class Market {
  final String id;
  final String name;
  final String displayName;
  final String type;
  final bool isLive;
  final bool isActive;
  final List<Selection> selections;
  final Map<String, dynamic>? metadata;

  const Market({
    required this.id,
    required this.name,
    required this.displayName,
    required this.type,
    required this.isLive,
    required this.isActive,
    required this.selections,
    this.metadata,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      type: json['type'] as String,
      isLive: json['is_live'] as bool,
      isActive: json['is_active'] as bool,
      selections: (json['selections'] as List)
          .map((e) => Selection.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'type': type,
      'is_live': isLive,
      'is_active': isActive,
      'selections': selections.map((e) => e.toJson()).toList(),
      'metadata': metadata,
    };
  }

  Market copyWith({
    String? id,
    String? name,
    String? displayName,
    String? type,
    bool? isLive,
    bool? isActive,
    List<Selection>? selections,
    Map<String, dynamic>? metadata,
  }) {
    return Market(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      isLive: isLive ?? this.isLive,
      isActive: isActive ?? this.isActive,
      selections: selections ?? this.selections,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Market && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Selection {
  final String id;
  final String name;
  final String displayName;
  final double odds;
  final bool isActive;
  final bool isWinning;
  final Map<String, dynamic>? metadata;

  const Selection({
    required this.id,
    required this.name,
    required this.displayName,
    required this.odds,
    required this.isActive,
    required this.isWinning,
    this.metadata,
  });

  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      odds: (json['odds'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      isWinning: json['is_winning'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'odds': odds,
      'is_active': isActive,
      'is_winning': isWinning,
      'metadata': metadata,
    };
  }

  Selection copyWith({
    String? id,
    String? name,
    String? displayName,
    double? odds,
    bool? isActive,
    bool? isWinning,
    Map<String, dynamic>? metadata,
  }) {
    return Selection(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      odds: odds ?? this.odds,
      isActive: isActive ?? this.isActive,
      isWinning: isWinning ?? this.isWinning,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedOdds => odds.toStringAsFixed(2);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Selection && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}