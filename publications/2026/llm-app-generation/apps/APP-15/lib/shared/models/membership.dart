import 'package:hive/hive.dart';

part 'membership.g.dart';

@HiveType(typeId: 6)
class Membership extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final MembershipPlan plan;

  @HiveField(3)
  final MembershipStatus status;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime? endDate;

  @HiveField(6)
  final DateTime nextBillingDate;

  @HiveField(7)
  final double monthlyFee;

  @HiveField(8)
  final PaymentMethod paymentMethod;

  @HiveField(9)
  final String? cardLastFour;

  @HiveField(10)
  final double outstandingBalance;

  @HiveField(11)
  final List<String> includedLocations;

  @HiveField(12)
  final int guestPassesPerMonth;

  @HiveField(13)
  final bool hasPersonalTraining;

  @HiveField(14)
  final bool hasGroupClasses;

  @HiveField(15)
  final bool hasNutritionConsultation;

  @HiveField(16)
  final DateTime? freezeStartDate;

  @HiveField(17)
  final DateTime? freezeEndDate;

  @HiveField(18)
  final List<Transaction> transactionHistory;

  Membership({
    required this.id,
    required this.userId,
    required this.plan,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.nextBillingDate,
    required this.monthlyFee,
    required this.paymentMethod,
    this.cardLastFour,
    this.outstandingBalance = 0.0,
    this.includedLocations = const [],
    this.guestPassesPerMonth = 0,
    this.hasPersonalTraining = false,
    this.hasGroupClasses = false,
    this.hasNutritionConsultation = false,
    this.freezeStartDate,
    this.freezeEndDate,
    this.transactionHistory = const [],
  });

  bool get isActive => status == MembershipStatus.active;
  bool get isFrozen => status == MembershipStatus.frozen;
  bool get isPastDue => status == MembershipStatus.pastDue;
  bool get hasOutstandingBalance => outstandingBalance > 0;

  String get planDisplayName {
    switch (plan) {
      case MembershipPlan.basic:
        return 'Basic';
      case MembershipPlan.premium:
        return 'Premium';
      case MembershipPlan.vip:
        return 'VIP';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case MembershipStatus.active:
        return 'Active';
      case MembershipStatus.frozen:
        return 'Frozen';
      case MembershipStatus.cancelled:
        return 'Cancelled';
      case MembershipStatus.pastDue:
        return 'Past Due';
      case MembershipStatus.suspended:
        return 'Suspended';
    }
  }

  Membership copyWith({
    String? id,
    String? userId,
    MembershipPlan? plan,
    MembershipStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    double? monthlyFee,
    PaymentMethod? paymentMethod,
    String? cardLastFour,
    double? outstandingBalance,
    List<String>? includedLocations,
    int? guestPassesPerMonth,
    bool? hasPersonalTraining,
    bool? hasGroupClasses,
    bool? hasNutritionConsultation,
    DateTime? freezeStartDate,
    DateTime? freezeEndDate,
    List<Transaction>? transactionHistory,
  }) {
    return Membership(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardLastFour: cardLastFour ?? this.cardLastFour,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      includedLocations: includedLocations ?? this.includedLocations,
      guestPassesPerMonth: guestPassesPerMonth ?? this.guestPassesPerMonth,
      hasPersonalTraining: hasPersonalTraining ?? this.hasPersonalTraining,
      hasGroupClasses: hasGroupClasses ?? this.hasGroupClasses,
      hasNutritionConsultation: hasNutritionConsultation ?? this.hasNutritionConsultation,
      freezeStartDate: freezeStartDate ?? this.freezeStartDate,
      freezeEndDate: freezeEndDate ?? this.freezeEndDate,
      transactionHistory: transactionHistory ?? this.transactionHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plan': plan.name,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'nextBillingDate': nextBillingDate.toIso8601String(),
      'monthlyFee': monthlyFee,
      'paymentMethod': paymentMethod.name,
      'cardLastFour': cardLastFour,
      'outstandingBalance': outstandingBalance,
      'includedLocations': includedLocations,
      'guestPassesPerMonth': guestPassesPerMonth,
      'hasPersonalTraining': hasPersonalTraining,
      'hasGroupClasses': hasGroupClasses,
      'hasNutritionConsultation': hasNutritionConsultation,
      'freezeStartDate': freezeStartDate?.toIso8601String(),
      'freezeEndDate': freezeEndDate?.toIso8601String(),
      'transactionHistory': transactionHistory.map((t) => t.toJson()).toList(),
    };
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'],
      userId: json['userId'],
      plan: MembershipPlan.values.firstWhere(
        (e) => e.name == json['plan'],
        orElse: () => MembershipPlan.basic,
      ),
      status: MembershipStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MembershipStatus.active,
      ),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      nextBillingDate: DateTime.parse(json['nextBillingDate']),
      monthlyFee: (json['monthlyFee'] ?? 0.0).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.creditCard,
      ),
      cardLastFour: json['cardLastFour'],
      outstandingBalance: (json['outstandingBalance'] ?? 0.0).toDouble(),
      includedLocations: List<String>.from(json['includedLocations'] ?? []),
      guestPassesPerMonth: json['guestPassesPerMonth'] ?? 0,
      hasPersonalTraining: json['hasPersonalTraining'] ?? false,
      hasGroupClasses: json['hasGroupClasses'] ?? false,
      hasNutritionConsultation: json['hasNutritionConsultation'] ?? false,
      freezeStartDate: json['freezeStartDate'] != null 
          ? DateTime.parse(json['freezeStartDate']) 
          : null,
      freezeEndDate: json['freezeEndDate'] != null 
          ? DateTime.parse(json['freezeEndDate']) 
          : null,
      transactionHistory: (json['transactionHistory'] as List<dynamic>?)
          ?.map((t) => Transaction.fromJson(t))
          .toList() ?? [],
    );
  }
}

@HiveType(typeId: 7)
enum MembershipPlan {
  @HiveField(0)
  basic,
  @HiveField(1)
  premium,
  @HiveField(2)
  vip,
}

@HiveType(typeId: 8)
enum MembershipStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  frozen,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  pastDue,
  @HiveField(4)
  suspended,
}

@HiveType(typeId: 9)
enum PaymentMethod {
  @HiveField(0)
  creditCard,
  @HiveField(1)
  debitCard,
  @HiveField(2)
  bankTransfer,
  @HiveField(3)
  paypal,
}

@HiveType(typeId: 10)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final TransactionType type;

  @HiveField(4)
  final TransactionStatus status;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String? paymentMethodUsed;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    this.paymentMethodUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'type': type.name,
      'status': status.name,
      'description': description,
      'paymentMethodUsed': paymentMethodUsed,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.payment,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
      description: json['description'],
      paymentMethodUsed: json['paymentMethodUsed'],
    );
  }
}

@HiveType(typeId: 11)
enum TransactionType {
  @HiveField(0)
  payment,
  @HiveField(1)
  refund,
  @HiveField(2)
  fee,
  @HiveField(3)
  adjustment,
}

@HiveType(typeId: 12)
enum TransactionStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  completed,
  @HiveField(2)
  failed,
  @HiveField(3)
  cancelled,
}