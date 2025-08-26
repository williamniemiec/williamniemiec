class LoyaltyAccount {
  final String id;
  final String userId;
  final int loyaltyCrumbs;
  final double crumblCash;
  final int totalPointsEarned;
  final double totalAmountSpent;
  final List<LoyaltyTransaction> transactions;
  final List<Reward> availableRewards;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LoyaltyAccount({
    required this.id,
    required this.userId,
    required this.loyaltyCrumbs,
    required this.crumblCash,
    required this.totalPointsEarned,
    required this.totalAmountSpent,
    this.transactions = const [],
    this.availableRewards = const [],
    required this.createdAt,
    this.updatedAt,
  });

  // Calculate progress towards next $10 Crumbl Cash (100 points = $10)
  double get progressToNextReward => (loyaltyCrumbs % 100) / 100.0;
  int get pointsToNextReward => 100 - (loyaltyCrumbs % 100);
  bool get canRedeemCrumblCash => loyaltyCrumbs >= 100;

  factory LoyaltyAccount.fromJson(Map<String, dynamic> json) {
    return LoyaltyAccount(
      id: json['id'] as String,
      userId: json['userId'] as String,
      loyaltyCrumbs: json['loyaltyCrumbs'] as int,
      crumblCash: (json['crumblCash'] as num).toDouble(),
      totalPointsEarned: json['totalPointsEarned'] as int,
      totalAmountSpent: (json['totalAmountSpent'] as num).toDouble(),
      transactions: (json['transactions'] as List? ?? [])
          .map((t) => LoyaltyTransaction.fromJson(t as Map<String, dynamic>))
          .toList(),
      availableRewards: (json['availableRewards'] as List? ?? [])
          .map((r) => Reward.fromJson(r as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'loyaltyCrumbs': loyaltyCrumbs,
      'crumblCash': crumblCash,
      'totalPointsEarned': totalPointsEarned,
      'totalAmountSpent': totalAmountSpent,
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'availableRewards': availableRewards.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  LoyaltyAccount copyWith({
    String? id,
    String? userId,
    int? loyaltyCrumbs,
    double? crumblCash,
    int? totalPointsEarned,
    double? totalAmountSpent,
    List<LoyaltyTransaction>? transactions,
    List<Reward>? availableRewards,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LoyaltyAccount(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      loyaltyCrumbs: loyaltyCrumbs ?? this.loyaltyCrumbs,
      crumblCash: crumblCash ?? this.crumblCash,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      totalAmountSpent: totalAmountSpent ?? this.totalAmountSpent,
      transactions: transactions ?? this.transactions,
      availableRewards: availableRewards ?? this.availableRewards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum LoyaltyTransactionType {
  earned,
  redeemed,
  expired,
  bonus,
}

class LoyaltyTransaction {
  final String id;
  final LoyaltyTransactionType type;
  final int points;
  final double? cashValue;
  final String description;
  final String? orderId;
  final DateTime createdAt;

  const LoyaltyTransaction({
    required this.id,
    required this.type,
    required this.points,
    this.cashValue,
    required this.description,
    this.orderId,
    required this.createdAt,
  });

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      id: json['id'] as String,
      type: LoyaltyTransactionType.values.firstWhere(
        (t) => t.name == json['type'],
      ),
      points: json['points'] as int,
      cashValue: (json['cashValue'] as num?)?.toDouble(),
      description: json['description'] as String,
      orderId: json['orderId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'points': points,
      'cashValue': cashValue,
      'description': description,
      'orderId': orderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum RewardType {
  freeCookie,
  discount,
  crumblCash,
  birthdaySpecial,
}

class Reward {
  final String id;
  final RewardType type;
  final String title;
  final String description;
  final String? imageUrl;
  final double? discountAmount;
  final double? discountPercentage;
  final int? requiredPoints;
  final DateTime? expiresAt;
  final bool isRedeemed;
  final DateTime? redeemedAt;

  const Reward({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.imageUrl,
    this.discountAmount,
    this.discountPercentage,
    this.requiredPoints,
    this.expiresAt,
    this.isRedeemed = false,
    this.redeemedAt,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isAvailable => !isRedeemed && !isExpired;

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as String,
      type: RewardType.values.firstWhere(
        (t) => t.name == json['type'],
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      requiredPoints: json['requiredPoints'] as int?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isRedeemed: json['isRedeemed'] as bool? ?? false,
      redeemedAt: json['redeemedAt'] != null
          ? DateTime.parse(json['redeemedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'discountAmount': discountAmount,
      'discountPercentage': discountPercentage,
      'requiredPoints': requiredPoints,
      'expiresAt': expiresAt?.toIso8601String(),
      'isRedeemed': isRedeemed,
      'redeemedAt': redeemedAt?.toIso8601String(),
    };
  }

  Reward copyWith({
    String? id,
    RewardType? type,
    String? title,
    String? description,
    String? imageUrl,
    double? discountAmount,
    double? discountPercentage,
    int? requiredPoints,
    DateTime? expiresAt,
    bool? isRedeemed,
    DateTime? redeemedAt,
  }) {
    return Reward(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      expiresAt: expiresAt ?? this.expiresAt,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      redeemedAt: redeemedAt ?? this.redeemedAt,
    );
  }
}