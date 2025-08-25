enum SubscriptionTier {
  free,
  premium,
}

enum SubscriptionPeriod {
  weekly,
  monthly,
  yearly,
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final SubscriptionTier tier;
  final SubscriptionPeriod period;
  final double price;
  final String currency;
  final List<String> features;
  final bool isPopular;
  final String? discountText;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.period,
    required this.price,
    this.currency = 'USD',
    this.features = const [],
    this.isPopular = false,
    this.discountText,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      period: SubscriptionPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => SubscriptionPeriod.monthly,
      ),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      features: List<String>.from(json['features'] as List? ?? []),
      isPopular: json['isPopular'] as bool? ?? false,
      discountText: json['discountText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tier': tier.name,
      'period': period.name,
      'price': price,
      'currency': currency,
      'features': features,
      'isPopular': isPopular,
      'discountText': discountText,
    };
  }
}

class UserSubscription {
  final String userId;
  final SubscriptionPlan plan;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool autoRenew;
  final String? transactionId;
  final int remainingGenerations;
  final int totalGenerationsUsed;

  const UserSubscription({
    required this.userId,
    required this.plan,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.autoRenew = true,
    this.transactionId,
    this.remainingGenerations = 0,
    this.totalGenerationsUsed = 0,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      userId: json['userId'] as String,
      plan: SubscriptionPlan.fromJson(json['plan'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : null,
      isActive: json['isActive'] as bool? ?? true,
      autoRenew: json['autoRenew'] as bool? ?? true,
      transactionId: json['transactionId'] as String?,
      remainingGenerations: json['remainingGenerations'] as int? ?? 0,
      totalGenerationsUsed: json['totalGenerationsUsed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'plan': plan.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'autoRenew': autoRenew,
      'transactionId': transactionId,
      'remainingGenerations': remainingGenerations,
      'totalGenerationsUsed': totalGenerationsUsed,
    };
  }

  UserSubscription copyWith({
    String? userId,
    SubscriptionPlan? plan,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? autoRenew,
    String? transactionId,
    int? remainingGenerations,
    int? totalGenerationsUsed,
  }) {
    return UserSubscription(
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      autoRenew: autoRenew ?? this.autoRenew,
      transactionId: transactionId ?? this.transactionId,
      remainingGenerations: remainingGenerations ?? this.remainingGenerations,
      totalGenerationsUsed: totalGenerationsUsed ?? this.totalGenerationsUsed,
    );
  }

  bool get isPremium => plan.tier == SubscriptionTier.premium && isActive;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);
  bool get canGenerate => isPremium || remainingGenerations > 0;
}