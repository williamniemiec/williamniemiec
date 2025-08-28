class SleeperPick {
  final String id;
  final String playerId;
  final String playerName;
  final String playerPosition;
  final String playerTeam;
  final String statType;
  final double line;
  final PickType pickType; // more or less
  final double odds;
  final double payout;
  final String gameId;
  final DateTime gameTime;
  final String opponent;
  final PickStatus status;
  final Map<String, dynamic> metadata;

  const SleeperPick({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.playerPosition,
    required this.playerTeam,
    required this.statType,
    required this.line,
    required this.pickType,
    required this.odds,
    required this.payout,
    required this.gameId,
    required this.gameTime,
    required this.opponent,
    required this.status,
    this.metadata = const {},
  });

  factory SleeperPick.fromJson(Map<String, dynamic> json) {
    return SleeperPick(
      id: json['id'] as String,
      playerId: json['player_id'] as String,
      playerName: json['player_name'] as String,
      playerPosition: json['player_position'] as String,
      playerTeam: json['player_team'] as String,
      statType: json['stat_type'] as String,
      line: (json['line'] as num).toDouble(),
      pickType: PickType.values.firstWhere(
        (e) => e.name == json['pick_type'],
        orElse: () => PickType.more,
      ),
      odds: (json['odds'] as num).toDouble(),
      payout: (json['payout'] as num).toDouble(),
      gameId: json['game_id'] as String,
      gameTime: DateTime.parse(json['game_time'] as String),
      opponent: json['opponent'] as String,
      status: PickStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PickStatus.pending,
      ),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'player_name': playerName,
      'player_position': playerPosition,
      'player_team': playerTeam,
      'stat_type': statType,
      'line': line,
      'pick_type': pickType.name,
      'odds': odds,
      'payout': payout,
      'game_id': gameId,
      'game_time': gameTime.toIso8601String(),
      'opponent': opponent,
      'status': status.name,
      'metadata': metadata,
    };
  }

  String get displayText => '$playerName ${pickType.displayText} $line $statType';
  String get matchup => '$playerTeam vs $opponent';
  bool get isActive => status == PickStatus.pending;
  bool get isWon => status == PickStatus.won;
  bool get isLost => status == PickStatus.lost;
}

enum PickType {
  more,
  less;

  String get displayText {
    switch (this) {
      case PickType.more:
        return 'MORE';
      case PickType.less:
        return 'LESS';
    }
  }
}

enum PickStatus {
  pending,
  won,
  lost,
  cancelled,
  void_pick;

  String get displayText {
    switch (this) {
      case PickStatus.pending:
        return 'Pending';
      case PickStatus.won:
        return 'Won';
      case PickStatus.lost:
        return 'Lost';
      case PickStatus.cancelled:
        return 'Cancelled';
      case PickStatus.void_pick:
        return 'Void';
    }
  }
}

class PickEntry {
  final String id;
  final String userId;
  final List<SleeperPick> picks;
  final double entryAmount;
  final double potentialPayout;
  final double totalOdds;
  final EntryStatus status;
  final DateTime createdAt;
  final DateTime? settledAt;
  final double? finalPayout;
  final Map<String, dynamic> metadata;

  const PickEntry({
    required this.id,
    required this.userId,
    required this.picks,
    required this.entryAmount,
    required this.potentialPayout,
    required this.totalOdds,
    required this.status,
    required this.createdAt,
    this.settledAt,
    this.finalPayout,
    this.metadata = const {},
  });

  factory PickEntry.fromJson(Map<String, dynamic> json) {
    return PickEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      picks: (json['picks'] as List<dynamic>)
          .map((p) => SleeperPick.fromJson(p as Map<String, dynamic>))
          .toList(),
      entryAmount: (json['entry_amount'] as num).toDouble(),
      potentialPayout: (json['potential_payout'] as num).toDouble(),
      totalOdds: (json['total_odds'] as num).toDouble(),
      status: EntryStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EntryStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      settledAt: json['settled_at'] != null 
          ? DateTime.parse(json['settled_at'] as String)
          : null,
      finalPayout: (json['final_payout'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'picks': picks.map((p) => p.toJson()).toList(),
      'entry_amount': entryAmount,
      'potential_payout': potentialPayout,
      'total_odds': totalOdds,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'settled_at': settledAt?.toIso8601String(),
      'final_payout': finalPayout,
      'metadata': metadata,
    };
  }

  int get pickCount => picks.length;
  bool get isActive => status == EntryStatus.pending;
  bool get isWon => status == EntryStatus.won;
  bool get isLost => status == EntryStatus.lost;
  bool get isSettled => settledAt != null;
  
  double get netProfit {
    if (finalPayout == null) return 0.0;
    return finalPayout! - entryAmount;
  }

  int get wonPicks => picks.where((p) => p.isWon).length;
  int get lostPicks => picks.where((p) => p.isLost).length;
  int get pendingPicks => picks.where((p) => p.isActive).length;
}

enum EntryStatus {
  pending,
  won,
  lost,
  cancelled,
  partial_win;

  String get displayText {
    switch (this) {
      case EntryStatus.pending:
        return 'Pending';
      case EntryStatus.won:
        return 'Won';
      case EntryStatus.lost:
        return 'Lost';
      case EntryStatus.cancelled:
        return 'Cancelled';
      case EntryStatus.partial_win:
        return 'Partial Win';
    }
  }
}

class UserBalance {
  final String userId;
  final double balance;
  final double pendingBalance;
  final double lifetimeDeposits;
  final double lifetimeWithdrawals;
  final double lifetimeWinnings;
  final DateTime lastUpdated;
  final Map<String, dynamic> metadata;

  const UserBalance({
    required this.userId,
    required this.balance,
    this.pendingBalance = 0.0,
    this.lifetimeDeposits = 0.0,
    this.lifetimeWithdrawals = 0.0,
    this.lifetimeWinnings = 0.0,
    required this.lastUpdated,
    this.metadata = const {},
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      pendingBalance: (json['pending_balance'] as num?)?.toDouble() ?? 0.0,
      lifetimeDeposits: (json['lifetime_deposits'] as num?)?.toDouble() ?? 0.0,
      lifetimeWithdrawals: (json['lifetime_withdrawals'] as num?)?.toDouble() ?? 0.0,
      lifetimeWinnings: (json['lifetime_winnings'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'balance': balance,
      'pending_balance': pendingBalance,
      'lifetime_deposits': lifetimeDeposits,
      'lifetime_withdrawals': lifetimeWithdrawals,
      'lifetime_winnings': lifetimeWinnings,
      'last_updated': lastUpdated.toIso8601String(),
      'metadata': metadata,
    };
  }

  double get availableBalance => balance - pendingBalance;
  double get netProfit => lifetimeWinnings - lifetimeDeposits;
  bool get hasAvailableFunds => availableBalance > 0;
}

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String? description;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? paymentMethodId;
  final Map<String, dynamic> metadata;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.description,
    required this.status,
    required this.createdAt,
    this.processedAt,
    this.paymentMethodId,
    this.metadata = const {},
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.deposit,
      ),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      processedAt: json['processed_at'] != null 
          ? DateTime.parse(json['processed_at'] as String)
          : null,
      paymentMethodId: json['payment_method_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'amount': amount,
      'description': description,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'payment_method_id': paymentMethodId,
      'metadata': metadata,
    };
  }

  bool get isDeposit => type == TransactionType.deposit;
  bool get isWithdrawal => type == TransactionType.withdrawal;
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;
}

enum TransactionType {
  deposit,
  withdrawal,
  win,
  loss,
  refund,
  bonus;

  String get displayText {
    switch (this) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.win:
        return 'Win';
      case TransactionType.loss:
        return 'Loss';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.bonus:
        return 'Bonus';
    }
  }
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled;

  String get displayText {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}