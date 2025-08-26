// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as String,
      type: $enumDecode(_$SubscriptionTypeEnumMap, json['type']),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      productId: json['productId'] as String?,
      transactionId: json['transactionId'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SubscriptionTypeEnumMap[instance.type]!,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'productId': instance.productId,
      'transactionId': instance.transactionId,
      'price': instance.price,
      'currency': instance.currency,
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.free: 'free',
  SubscriptionType.weekly: 'weekly',
  SubscriptionType.monthly: 'monthly',
  SubscriptionType.lifetime: 'lifetime',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.cancelled: 'cancelled',
  SubscriptionStatus.pending: 'pending',
};
