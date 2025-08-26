import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

enum SubscriptionType {
  free,
  weekly,
  monthly,
  lifetime,
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  pending,
}

@JsonSerializable()
class Subscription {
  final String id;
  final SubscriptionType type;
  final SubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? productId;
  final String? transactionId;
  final double? price;
  final String? currency;

  const Subscription({
    required this.id,
    required this.type,
    required this.status,
    this.startDate,
    this.endDate,
    this.productId,
    this.transactionId,
    this.price,
    this.currency,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  Subscription copyWith({
    String? id,
    SubscriptionType? type,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? productId,
    String? transactionId,
    double? price,
    String? currency,
  }) {
    return Subscription(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      productId: productId ?? this.productId,
      transactionId: transactionId ?? this.transactionId,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }

  bool get isActive {
    if (status != SubscriptionStatus.active) return false;
    if (type == SubscriptionType.lifetime) return true;
    if (endDate == null) return false;
    return endDate!.isAfter(DateTime.now());
  }

  bool get isPremium => type != SubscriptionType.free && isActive;

  static Subscription createFree() {
    return Subscription(
      id: 'free_${DateTime.now().millisecondsSinceEpoch}',
      type: SubscriptionType.free,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
    );
  }

  String get displayName {
    switch (type) {
      case SubscriptionType.free:
        return 'Free';
      case SubscriptionType.weekly:
        return 'Weekly Premium';
      case SubscriptionType.monthly:
        return 'Monthly Premium';
      case SubscriptionType.lifetime:
        return 'Lifetime Premium';
    }
  }

  Duration? get remainingTime {
    if (!isActive || endDate == null) return null;
    final now = DateTime.now();
    if (endDate!.isBefore(now)) return null;
    return endDate!.difference(now);
  }
}