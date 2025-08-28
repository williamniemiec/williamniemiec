enum BetType { single, multiple, system }

enum BetStatus { pending, won, lost, cashout, cancelled, voided }

enum MarketType {
  matchResult, // 1X2
  overUnder,
  bothTeamsToScore,
  correctScore,
  handicap,
  totalGoals,
  firstGoalscorer,
  anytimeGoalscorer,
  halfTimeFullTime,
  doubleChance,
  drawNoBet,
  nextGoal,
  corners,
  cards,
  penalties,
  custom
}

class Bet {
  final String id;
  final String userId;
  final BetType type;
  final BetStatus status;
  final double stake;
  final double totalOdds;
  final double? potentialWin;
  final double? actualWin;
  final DateTime placedAt;
  final DateTime? settledAt;
  final List<BetSelection> selections;
  final bool isLive;
  final double? cashOutValue;
  final bool canCashOut;
  final String? cashOutReason;

  Bet({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.stake,
    required this.totalOdds,
    this.potentialWin,
    this.actualWin,
    required this.placedAt,
    this.settledAt,
    required this.selections,
    required this.isLive,
    this.cashOutValue,
    required this.canCashOut,
    this.cashOutReason,
  });

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: BetType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BetType.single,
      ),
      status: BetStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BetStatus.pending,
      ),
      stake: (json['stake'] as num).toDouble(),
      totalOdds: (json['total_odds'] as num).toDouble(),
      potentialWin: json['potential_win'] != null
          ? (json['potential_win'] as num).toDouble()
          : null,
      actualWin: json['actual_win'] != null
          ? (json['actual_win'] as num).toDouble()
          : null,
      placedAt: DateTime.parse(json['placed_at'] as String),
      settledAt: json['settled_at'] != null
          ? DateTime.parse(json['settled_at'] as String)
          : null,
      selections: (json['selections'] as List)
          .map((e) => BetSelection.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLive: json['is_live'] as bool,
      cashOutValue: json['cash_out_value'] != null
          ? (json['cash_out_value'] as num).toDouble()
          : null,
      canCashOut: json['can_cash_out'] as bool,
      cashOutReason: json['cash_out_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'status': status.name,
      'stake': stake,
      'total_odds': totalOdds,
      'potential_win': potentialWin,
      'actual_win': actualWin,
      'placed_at': placedAt.toIso8601String(),
      'settled_at': settledAt?.toIso8601String(),
      'selections': selections.map((e) => e.toJson()).toList(),
      'is_live': isLive,
      'cash_out_value': cashOutValue,
      'can_cash_out': canCashOut,
      'cash_out_reason': cashOutReason,
    };
  }

  Bet copyWith({
    String? id,
    String? userId,
    BetType? type,
    BetStatus? status,
    double? stake,
    double? totalOdds,
    double? potentialWin,
    double? actualWin,
    DateTime? placedAt,
    DateTime? settledAt,
    List<BetSelection>? selections,
    bool? isLive,
    double? cashOutValue,
    bool? canCashOut,
    String? cashOutReason,
  }) {
    return Bet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      stake: stake ?? this.stake,
      totalOdds: totalOdds ?? this.totalOdds,
      potentialWin: potentialWin ?? this.potentialWin,
      actualWin: actualWin ?? this.actualWin,
      placedAt: placedAt ?? this.placedAt,
      settledAt: settledAt ?? this.settledAt,
      selections: selections ?? this.selections,
      isLive: isLive ?? this.isLive,
      cashOutValue: cashOutValue ?? this.cashOutValue,
      canCashOut: canCashOut ?? this.canCashOut,
      cashOutReason: cashOutReason ?? this.cashOutReason,
    );
  }

  String get formattedStake => 'R\$ ${stake.toStringAsFixed(2)}';
  String get formattedTotalOdds => totalOdds.toStringAsFixed(2);
  String get formattedPotentialWin => 
      potentialWin != null ? 'R\$ ${potentialWin!.toStringAsFixed(2)}' : '-';
  String get formattedActualWin => 
      actualWin != null ? 'R\$ ${actualWin!.toStringAsFixed(2)}' : '-';
  String get formattedCashOutValue => 
      cashOutValue != null ? 'R\$ ${cashOutValue!.toStringAsFixed(2)}' : '-';

  bool get isSettled => status == BetStatus.won || 
                       status == BetStatus.lost || 
                       status == BetStatus.cashout ||
                       status == BetStatus.voided;

  bool get isWinning => status == BetStatus.won;
  bool get isLosing => status == BetStatus.lost;
  bool get isPending => status == BetStatus.pending;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class BetSelection {
  final String id;
  final String eventId;
  final String eventName;
  final String marketId;
  final String marketName;
  final MarketType marketType;
  final String selectionId;
  final String selectionName;
  final double odds;
  final BetStatus status;
  final String? result;
  final DateTime eventStartTime;
  final bool isLive;
  final Map<String, dynamic>? metadata;

  BetSelection({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.marketId,
    required this.marketName,
    required this.marketType,
    required this.selectionId,
    required this.selectionName,
    required this.odds,
    required this.status,
    this.result,
    required this.eventStartTime,
    required this.isLive,
    this.metadata,
  });

  factory BetSelection.fromJson(Map<String, dynamic> json) {
    return BetSelection(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      eventName: json['event_name'] as String,
      marketId: json['market_id'] as String,
      marketName: json['market_name'] as String,
      marketType: MarketType.values.firstWhere(
        (e) => e.name == json['market_type'],
        orElse: () => MarketType.custom,
      ),
      selectionId: json['selection_id'] as String,
      selectionName: json['selection_name'] as String,
      odds: (json['odds'] as num).toDouble(),
      status: BetStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BetStatus.pending,
      ),
      result: json['result'] as String?,
      eventStartTime: DateTime.parse(json['event_start_time'] as String),
      isLive: json['is_live'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'event_name': eventName,
      'market_id': marketId,
      'market_name': marketName,
      'market_type': marketType.name,
      'selection_id': selectionId,
      'selection_name': selectionName,
      'odds': odds,
      'status': status.name,
      'result': result,
      'event_start_time': eventStartTime.toIso8601String(),
      'is_live': isLive,
      'metadata': metadata,
    };
  }

  BetSelection copyWith({
    String? id,
    String? eventId,
    String? eventName,
    String? marketId,
    String? marketName,
    MarketType? marketType,
    String? selectionId,
    String? selectionName,
    double? odds,
    BetStatus? status,
    String? result,
    DateTime? eventStartTime,
    bool? isLive,
    Map<String, dynamic>? metadata,
  }) {
    return BetSelection(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      marketId: marketId ?? this.marketId,
      marketName: marketName ?? this.marketName,
      marketType: marketType ?? this.marketType,
      selectionId: selectionId ?? this.selectionId,
      selectionName: selectionName ?? this.selectionName,
      odds: odds ?? this.odds,
      status: status ?? this.status,
      result: result ?? this.result,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      isLive: isLive ?? this.isLive,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedOdds => odds.toStringAsFixed(2);

  bool get isSettled => status == BetStatus.won || 
                       status == BetStatus.lost || 
                       status == BetStatus.voided;

  bool get isWinning => status == BetStatus.won;
  bool get isLosing => status == BetStatus.lost;
  bool get isPending => status == BetStatus.pending;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BetSelection && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class BetSlip {
  final List<BetSelection> selections;
  final BetType betType;
  final double stake;
  final double totalOdds;
  final double potentialWin;
  final bool isValid;
  final List<String> errors;

  const BetSlip({
    required this.selections,
    required this.betType,
    required this.stake,
    required this.totalOdds,
    required this.potentialWin,
    required this.isValid,
    required this.errors,
  });

  factory BetSlip.empty() {
    return const BetSlip(
      selections: [],
      betType: BetType.single,
      stake: 0.0,
      totalOdds: 0.0,
      potentialWin: 0.0,
      isValid: false,
      errors: [],
    );
  }

  factory BetSlip.fromJson(Map<String, dynamic> json) {
    return BetSlip(
      selections: (json['selections'] as List)
          .map((e) => BetSelection.fromJson(e as Map<String, dynamic>))
          .toList(),
      betType: BetType.values.firstWhere(
        (e) => e.name == json['bet_type'],
        orElse: () => BetType.single,
      ),
      stake: (json['stake'] as num).toDouble(),
      totalOdds: (json['total_odds'] as num).toDouble(),
      potentialWin: (json['potential_win'] as num).toDouble(),
      isValid: json['is_valid'] as bool,
      errors: List<String>.from(json['errors'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selections': selections.map((e) => e.toJson()).toList(),
      'bet_type': betType.name,
      'stake': stake,
      'total_odds': totalOdds,
      'potential_win': potentialWin,
      'is_valid': isValid,
      'errors': errors,
    };
  }

  BetSlip copyWith({
    List<BetSelection>? selections,
    BetType? betType,
    double? stake,
    double? totalOdds,
    double? potentialWin,
    bool? isValid,
    List<String>? errors,
  }) {
    return BetSlip(
      selections: selections ?? this.selections,
      betType: betType ?? this.betType,
      stake: stake ?? this.stake,
      totalOdds: totalOdds ?? this.totalOdds,
      potentialWin: potentialWin ?? this.potentialWin,
      isValid: isValid ?? this.isValid,
      errors: errors ?? this.errors,
    );
  }

  BetSlip addSelection(BetSelection selection) {
    final newSelections = List<BetSelection>.from(selections);
    
    // Remove existing selection for the same market if exists
    newSelections.removeWhere((s) => s.marketId == selection.marketId);
    
    // Add new selection
    newSelections.add(selection);
    
    return _recalculate(newSelections);
  }

  BetSlip removeSelection(String selectionId) {
    final newSelections = selections
        .where((s) => s.id != selectionId)
        .toList();
    
    return _recalculate(newSelections);
  }

  BetSlip updateStake(double newStake) {
    return _recalculate(selections, newStake: newStake);
  }

  BetSlip updateBetType(BetType newBetType) {
    return _recalculate(selections, newBetType: newBetType);
  }

  BetSlip clear() {
    return BetSlip.empty();
  }

  BetSlip _recalculate(List<BetSelection> newSelections, {
    double? newStake,
    BetType? newBetType,
  }) {
    final calculatedStake = newStake ?? stake;
    final calculatedBetType = newBetType ?? betType;
    
    if (newSelections.isEmpty) {
      return BetSlip.empty();
    }

    double calculatedTotalOdds = 1.0;
    final errors = <String>[];

    // Calculate total odds based on bet type
    switch (calculatedBetType) {
      case BetType.single:
        if (newSelections.length > 1) {
          errors.add('Single bet can only have one selection');
        }
        calculatedTotalOdds = newSelections.isNotEmpty ? newSelections.first.odds : 1.0;
        break;
      case BetType.multiple:
        if (newSelections.length < 2) {
          errors.add('Multiple bet requires at least 2 selections');
        }
        for (final selection in newSelections) {
          calculatedTotalOdds *= selection.odds;
        }
        break;
      case BetType.system:
        // System bet calculation would be more complex
        // For now, treat as multiple
        if (newSelections.length < 3) {
          errors.add('System bet requires at least 3 selections');
        }
        for (final selection in newSelections) {
          calculatedTotalOdds *= selection.odds;
        }
        break;
    }

    final calculatedPotentialWin = calculatedStake * calculatedTotalOdds;
    final isValid = errors.isEmpty && 
                   calculatedStake > 0 && 
                   newSelections.isNotEmpty;

    return BetSlip(
      selections: newSelections,
      betType: calculatedBetType,
      stake: calculatedStake,
      totalOdds: calculatedTotalOdds,
      potentialWin: calculatedPotentialWin,
      isValid: isValid,
      errors: errors,
    );
  }

  String get formattedStake => 'R\$ ${stake.toStringAsFixed(2)}';
  String get formattedTotalOdds => totalOdds.toStringAsFixed(2);
  String get formattedPotentialWin => 'R\$ ${potentialWin.toStringAsFixed(2)}';

  bool get isEmpty => selections.isEmpty;
  bool get isNotEmpty => selections.isNotEmpty;
  int get selectionCount => selections.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BetSlip && 
           other.selections.length == selections.length &&
           other.betType == betType &&
           other.stake == stake;
  }

  @override
  int get hashCode => Object.hash(selections, betType, stake);
}