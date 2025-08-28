import 'cart.dart';
import 'user.dart';
import 'coupon.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final Address shippingAddress;
  final Address? billingAddress;
  final OrderStatus status;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final String? couponCode;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final List<OrderStatusUpdate> statusUpdates;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    this.billingAddress,
    required this.status,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    this.couponCode,
    required this.paymentMethod,
    required this.createdAt,
    this.shippedAt,
    this.deliveredAt,
    this.trackingNumber,
    required this.statusUpdates,
  });

  String get displayStatus {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  bool get canCancel => status == OrderStatus.pending || status == OrderStatus.processing;
  bool get canTrack => status == OrderStatus.shipped && trackingNumber != null;
  bool get isCompleted => status == OrderStatus.delivered;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      shippingAddress: Address.fromJson(json['shippingAddress']),
      billingAddress: json['billingAddress'] != null
          ? Address.fromJson(json['billingAddress'])
          : null,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shipping: (json['shipping'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      couponCode: json['couponCode'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentMethod'],
        orElse: () => PaymentMethod.creditCard,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      shippedAt: json['shippedAt'] != null ? DateTime.parse(json['shippedAt']) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      trackingNumber: json['trackingNumber'],
      statusUpdates: (json['statusUpdates'] as List<dynamic>?)
              ?.map((update) => OrderStatusUpdate.fromJson(update))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'billingAddress': billingAddress?.toJson(),
      'status': status.toString().split('.').last,
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'discount': discount,
      'total': total,
      'couponCode': couponCode,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'shippedAt': shippedAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'statusUpdates': statusUpdates.map((update) => update.toJson()).toList(),
    };
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final String message;
  final DateTime timestamp;
  final String? location;

  OrderStatusUpdate({
    required this.status,
    required this.message,
    required this.timestamp,
    this.location,
  });

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) {
    return OrderStatusUpdate(
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
    };
  }
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
  klarna,
  afterpay,
}