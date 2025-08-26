import 'cookie.dart';
import 'store.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  completed,
  cancelled,
}

enum FulfillmentMethod {
  pickup,
  curbside,
  delivery,
  catering,
  shipping,
}

class OrderItem {
  final Cookie cookie;
  final int quantity;

  const OrderItem({
    required this.cookie,
    required this.quantity,
  });

  double get totalPrice => cookie.price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      cookie: Cookie.fromJson(json['cookie'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cookie': cookie.toJson(),
      'quantity': quantity,
    };
  }

  OrderItem copyWith({
    Cookie? cookie,
    int? quantity,
  }) {
    return OrderItem(
      cookie: cookie ?? this.cookie,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem &&
        other.cookie == cookie &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(cookie, quantity);
}

class Order {
  final String id;
  final List<OrderItem> items;
  final FulfillmentMethod fulfillmentMethod;
  final Store? store;
  final String? deliveryAddress;
  final DateTime? scheduledTime;
  final OrderStatus status;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? trackingNumber;

  const Order({
    required this.id,
    required this.items,
    required this.fulfillmentMethod,
    this.store,
    this.deliveryAddress,
    this.scheduledTime,
    required this.status,
    required this.subtotal,
    required this.tax,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    required this.total,
    this.specialInstructions,
    required this.createdAt,
    this.updatedAt,
    this.trackingNumber,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      fulfillmentMethod: FulfillmentMethod.values.firstWhere(
        (method) => method.name == json['fulfillmentMethod'],
      ),
      store: json['store'] != null
          ? Store.fromJson(json['store'] as Map<String, dynamic>)
          : null,
      deliveryAddress: json['deliveryAddress'] as String?,
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'] as String)
          : null,
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      trackingNumber: json['trackingNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'fulfillmentMethod': fulfillmentMethod.name,
      'store': store?.toJson(),
      'deliveryAddress': deliveryAddress,
      'scheduledTime': scheduledTime?.toIso8601String(),
      'status': status.name,
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'trackingNumber': trackingNumber,
    };
  }

  Order copyWith({
    String? id,
    List<OrderItem>? items,
    FulfillmentMethod? fulfillmentMethod,
    Store? store,
    String? deliveryAddress,
    DateTime? scheduledTime,
    OrderStatus? status,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? discount,
    double? total,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? trackingNumber,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      fulfillmentMethod: fulfillmentMethod ?? this.fulfillmentMethod,
      store: store ?? this.store,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Order(id: $id, status: $status, total: \$${total.toStringAsFixed(2)})';
  }
}