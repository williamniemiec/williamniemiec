import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 3)
class Subscription extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String type; // 'weekly', 'monthly', 'yearly'

  @HiveField(3)
  final String status; // 'active', 'expired', 'cancelled', 'pending'

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime expiryDate;

  @HiveField(6)
  final double price;

  @HiveField(7)
  final String currency;

  @HiveField(8)
  final String paymentMethod;

  @HiveField(9)
  final String? transactionId;

  @HiveField(10)
  final bool autoRenew;

  @HiveField(11)
  final DateTime? nextBillingDate;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime updatedAt;

  @HiveField(14)
  final Map<String, dynamic> features; // Subscription features

  Subscription({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.startDate,
    required this.expiryDate,
    required this.price,
    required this.currency,
    required this.paymentMethod,
    this.transactionId,
    required this.autoRenew,
    this.nextBillingDate,
    required this.createdAt,
    required this.updatedAt,
    required this.features,
  });

  // Factory constructor for creating Subscription from JSON
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      transactionId: json['transactionId'] as String?,
      autoRenew: json['autoRenew'] as bool,
      nextBillingDate: json['nextBillingDate'] != null
          ? DateTime.parse(json['nextBillingDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      features: Map<String, dynamic>.from(json['features'] as Map),
    );
  }

  // Convert Subscription to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'autoRenew': autoRenew,
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'features': features,
    };
  }

  // Helper methods
  bool get isActive => status == 'active' && expiryDate.isAfter(DateTime.now());

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  bool get willExpireSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';

  String get displayType {
    switch (type) {
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      case 'yearly':
        return 'Yearly';
      default:
        return type;
    }
  }

  String get displayStatus {
    switch (status) {
      case 'active':
        return 'Active';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  // Get subscription duration in days
  int get durationInDays {
    switch (type) {
      case 'weekly':
        return 7;
      case 'monthly':
        return 30;
      case 'yearly':
        return 365;
      default:
        return 0;
    }
  }

  // Check if subscription has a specific feature
  bool hasFeature(String featureName) {
    return features.containsKey(featureName) && features[featureName] == true;
  }

  // Get feature value
  T? getFeatureValue<T>(String featureName) {
    return features[featureName] as T?;
  }

  // Copy with method for updating subscription
  Subscription copyWith({
    String? id,
    String? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? expiryDate,
    double? price,
    String? currency,
    String? paymentMethod,
    String? transactionId,
    bool? autoRenew,
    DateTime? nextBillingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? features,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      autoRenew: autoRenew ?? this.autoRenew,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      features: features ?? this.features,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subscription && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Subscription(id: $id, type: $type, status: $status)';
  }
}