enum GameCategory { slots, liveTable, tableGames, crashGames, jackpots, newGames, popular }

enum GameProvider { 
  pragmaticPlay, 
  evolution, 
  netent, 
  playtech, 
  microgaming, 
  redTiger, 
  bigTimeGaming, 
  noLimit, 
  hacksaw,
  other 
}

class CasinoGame {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final String thumbnailUrl;
  final String? backgroundUrl;
  final GameCategory category;
  final GameProvider provider;
  final bool isLive;
  final bool isNew;
  final bool isPopular;
  final bool hasJackpot;
  final double? jackpotAmount;
  final double minBet;
  final double maxBet;
  final double? rtp; // Return to Player percentage
  final int? maxWin; // Maximum win multiplier
  final List<String> features;
  final Map<String, dynamic>? metadata;

  const CasinoGame({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    required this.thumbnailUrl,
    this.backgroundUrl,
    required this.category,
    required this.provider,
    required this.isLive,
    required this.isNew,
    required this.isPopular,
    required this.hasJackpot,
    this.jackpotAmount,
    required this.minBet,
    required this.maxBet,
    this.rtp,
    this.maxWin,
    required this.features,
    this.metadata,
  });

  factory CasinoGame.fromJson(Map<String, dynamic> json) {
    return CasinoGame(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String,
      backgroundUrl: json['background_url'] as String?,
      category: GameCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => GameCategory.slots,
      ),
      provider: GameProvider.values.firstWhere(
        (e) => e.name == json['provider'],
        orElse: () => GameProvider.other,
      ),
      isLive: json['is_live'] as bool,
      isNew: json['is_new'] as bool,
      isPopular: json['is_popular'] as bool,
      hasJackpot: json['has_jackpot'] as bool,
      jackpotAmount: json['jackpot_amount'] != null
          ? (json['jackpot_amount'] as num).toDouble()
          : null,
      minBet: (json['min_bet'] as num).toDouble(),
      maxBet: (json['max_bet'] as num).toDouble(),
      rtp: json['rtp'] != null ? (json['rtp'] as num).toDouble() : null,
      maxWin: json['max_win'] as int?,
      features: List<String>.from(json['features'] as List),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'background_url': backgroundUrl,
      'category': category.name,
      'provider': provider.name,
      'is_live': isLive,
      'is_new': isNew,
      'is_popular': isPopular,
      'has_jackpot': hasJackpot,
      'jackpot_amount': jackpotAmount,
      'min_bet': minBet,
      'max_bet': maxBet,
      'rtp': rtp,
      'max_win': maxWin,
      'features': features,
      'metadata': metadata,
    };
  }

  CasinoGame copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? thumbnailUrl,
    String? backgroundUrl,
    GameCategory? category,
    GameProvider? provider,
    bool? isLive,
    bool? isNew,
    bool? isPopular,
    bool? hasJackpot,
    double? jackpotAmount,
    double? minBet,
    double? maxBet,
    double? rtp,
    int? maxWin,
    List<String>? features,
    Map<String, dynamic>? metadata,
  }) {
    return CasinoGame(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      category: category ?? this.category,
      provider: provider ?? this.provider,
      isLive: isLive ?? this.isLive,
      isNew: isNew ?? this.isNew,
      isPopular: isPopular ?? this.isPopular,
      hasJackpot: hasJackpot ?? this.hasJackpot,
      jackpotAmount: jackpotAmount ?? this.jackpotAmount,
      minBet: minBet ?? this.minBet,
      maxBet: maxBet ?? this.maxBet,
      rtp: rtp ?? this.rtp,
      maxWin: maxWin ?? this.maxWin,
      features: features ?? this.features,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedMinBet => 'R\$ ${minBet.toStringAsFixed(2)}';
  String get formattedMaxBet => 'R\$ ${maxBet.toStringAsFixed(2)}';
  String get formattedJackpot => jackpotAmount != null 
      ? 'R\$ ${jackpotAmount!.toStringAsFixed(2)}' 
      : '';
  String get formattedRtp => rtp != null ? '${rtp!.toStringAsFixed(1)}%' : '';
  String get formattedMaxWin => maxWin != null ? '${maxWin}x' : '';

  String get providerDisplayName {
    switch (provider) {
      case GameProvider.pragmaticPlay:
        return 'Pragmatic Play';
      case GameProvider.evolution:
        return 'Evolution';
      case GameProvider.netent:
        return 'NetEnt';
      case GameProvider.playtech:
        return 'Playtech';
      case GameProvider.microgaming:
        return 'Microgaming';
      case GameProvider.redTiger:
        return 'Red Tiger';
      case GameProvider.bigTimeGaming:
        return 'Big Time Gaming';
      case GameProvider.noLimit:
        return 'No Limit City';
      case GameProvider.hacksaw:
        return 'Hacksaw Gaming';
      case GameProvider.other:
        return 'Other';
    }
  }

  String get categoryDisplayName {
    switch (category) {
      case GameCategory.slots:
        return 'Slots';
      case GameCategory.liveTable:
        return 'Live Casino';
      case GameCategory.tableGames:
        return 'Table Games';
      case GameCategory.crashGames:
        return 'Crash Games';
      case GameCategory.jackpots:
        return 'Jackpots';
      case GameCategory.newGames:
        return 'New Games';
      case GameCategory.popular:
        return 'Popular';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CasinoGame && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CasinoGame(id: $id, name: $name, category: $category)';
  }
}

class LiveTable {
  final String id;
  final String name;
  final String displayName;
  final String gameType; // blackjack, roulette, baccarat, etc.
  final String dealerName;
  final String? dealerImageUrl;
  final String tableImageUrl;
  final int playerCount;
  final int maxPlayers;
  final double minBet;
  final double maxBet;
  final bool isAvailable;
  final String language;
  final Map<String, dynamic>? gameState;

  const LiveTable({
    required this.id,
    required this.name,
    required this.displayName,
    required this.gameType,
    required this.dealerName,
    this.dealerImageUrl,
    required this.tableImageUrl,
    required this.playerCount,
    required this.maxPlayers,
    required this.minBet,
    required this.maxBet,
    required this.isAvailable,
    required this.language,
    this.gameState,
  });

  factory LiveTable.fromJson(Map<String, dynamic> json) {
    return LiveTable(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      gameType: json['game_type'] as String,
      dealerName: json['dealer_name'] as String,
      dealerImageUrl: json['dealer_image_url'] as String?,
      tableImageUrl: json['table_image_url'] as String,
      playerCount: json['player_count'] as int,
      maxPlayers: json['max_players'] as int,
      minBet: (json['min_bet'] as num).toDouble(),
      maxBet: (json['max_bet'] as num).toDouble(),
      isAvailable: json['is_available'] as bool,
      language: json['language'] as String,
      gameState: json['game_state'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'game_type': gameType,
      'dealer_name': dealerName,
      'dealer_image_url': dealerImageUrl,
      'table_image_url': tableImageUrl,
      'player_count': playerCount,
      'max_players': maxPlayers,
      'min_bet': minBet,
      'max_bet': maxBet,
      'is_available': isAvailable,
      'language': language,
      'game_state': gameState,
    };
  }

  LiveTable copyWith({
    String? id,
    String? name,
    String? displayName,
    String? gameType,
    String? dealerName,
    String? dealerImageUrl,
    String? tableImageUrl,
    int? playerCount,
    int? maxPlayers,
    double? minBet,
    double? maxBet,
    bool? isAvailable,
    String? language,
    Map<String, dynamic>? gameState,
  }) {
    return LiveTable(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      gameType: gameType ?? this.gameType,
      dealerName: dealerName ?? this.dealerName,
      dealerImageUrl: dealerImageUrl ?? this.dealerImageUrl,
      tableImageUrl: tableImageUrl ?? this.tableImageUrl,
      playerCount: playerCount ?? this.playerCount,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      minBet: minBet ?? this.minBet,
      maxBet: maxBet ?? this.maxBet,
      isAvailable: isAvailable ?? this.isAvailable,
      language: language ?? this.language,
      gameState: gameState ?? this.gameState,
    );
  }

  String get formattedMinBet => 'R\$ ${minBet.toStringAsFixed(2)}';
  String get formattedMaxBet => 'R\$ ${maxBet.toStringAsFixed(2)}';
  String get playerCountText => '$playerCount/$maxPlayers';
  
  bool get isFull => playerCount >= maxPlayers;
  bool get hasAvailableSeats => playerCount < maxPlayers;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiveTable && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Tournament {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final String? imageUrl;
  final DateTime startTime;
  final DateTime endTime;
  final double entryFee;
  final double prizePool;
  final int maxParticipants;
  final int currentParticipants;
  final List<String> eligibleGames;
  final List<TournamentPrize> prizes;
  final bool isActive;
  final bool isJoined;

  const Tournament({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    this.imageUrl,
    required this.startTime,
    required this.endTime,
    required this.entryFee,
    required this.prizePool,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.eligibleGames,
    required this.prizes,
    required this.isActive,
    required this.isJoined,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      entryFee: (json['entry_fee'] as num).toDouble(),
      prizePool: (json['prize_pool'] as num).toDouble(),
      maxParticipants: json['max_participants'] as int,
      currentParticipants: json['current_participants'] as int,
      eligibleGames: List<String>.from(json['eligible_games'] as List),
      prizes: (json['prizes'] as List)
          .map((e) => TournamentPrize.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['is_active'] as bool,
      isJoined: json['is_joined'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'image_url': imageUrl,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'entry_fee': entryFee,
      'prize_pool': prizePool,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'eligible_games': eligibleGames,
      'prizes': prizes.map((e) => e.toJson()).toList(),
      'is_active': isActive,
      'is_joined': isJoined,
    };
  }

  Tournament copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? imageUrl,
    DateTime? startTime,
    DateTime? endTime,
    double? entryFee,
    double? prizePool,
    int? maxParticipants,
    int? currentParticipants,
    List<String>? eligibleGames,
    List<TournamentPrize>? prizes,
    bool? isActive,
    bool? isJoined,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      entryFee: entryFee ?? this.entryFee,
      prizePool: prizePool ?? this.prizePool,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      eligibleGames: eligibleGames ?? this.eligibleGames,
      prizes: prizes ?? this.prizes,
      isActive: isActive ?? this.isActive,
      isJoined: isJoined ?? this.isJoined,
    );
  }

  String get formattedEntryFee => 'R\$ ${entryFee.toStringAsFixed(2)}';
  String get formattedPrizePool => 'R\$ ${prizePool.toStringAsFixed(2)}';
  String get participantsText => '$currentParticipants/$maxParticipants';
  
  bool get isFull => currentParticipants >= maxParticipants;
  bool get hasStarted => DateTime.now().isAfter(startTime);
  bool get hasEnded => DateTime.now().isAfter(endTime);
  bool get canJoin => isActive && !isFull && !hasStarted && !isJoined;

  Duration get timeUntilStart => startTime.difference(DateTime.now());
  Duration get timeUntilEnd => endTime.difference(DateTime.now());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tournament && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class TournamentPrize {
  final int position;
  final double amount;
  final String? description;

  const TournamentPrize({
    required this.position,
    required this.amount,
    this.description,
  });

  factory TournamentPrize.fromJson(Map<String, dynamic> json) {
    return TournamentPrize(
      position: json['position'] as int,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'amount': amount,
      'description': description,
    };
  }

  TournamentPrize copyWith({
    int? position,
    double? amount,
    String? description,
  }) {
    return TournamentPrize(
      position: position ?? this.position,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }

  String get formattedAmount => 'R\$ ${amount.toStringAsFixed(2)}';
  String get positionText {
    switch (position) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${position}th';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TournamentPrize && 
           other.position == position && 
           other.amount == amount;
  }

  @override
  int get hashCode => Object.hash(position, amount);
}