import 'cart_item.dart';
import 'user.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;
  final String status;
  final Address shippingAddress;
  final Address? billingAddress;
  final PaymentMethod paymentMethod;
  final String? promoCode;
  final DateTime orderDate;
  final DateTime? shippedDate;
  final DateTime? deliveredDate;
  final String? trackingNumber;
  final String shippingMethod;
  final List<OrderStatusUpdate> statusHistory;
  final String? notes;
  final bool isGift;
  final String? giftMessage;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.discount,
    required this.total,
    required this.status,
    required this.shippingAddress,
    this.billingAddress,
    required this.paymentMethod,
    this.promoCode,
    required this.orderDate,
    this.shippedDate,
    this.deliveredDate,
    this.trackingNumber,
    required this.shippingMethod,
    this.statusHistory = const [],
    this.notes,
    this.isGift = false,
    this.giftMessage,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e))
          .toList() ?? [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'Processing',
      shippingAddress: Address.fromJson(json['shippingAddress'] ?? {}),
      billingAddress: json['billingAddress'] != null 
          ? Address.fromJson(json['billingAddress'])
          : null,
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod'] ?? {}),
      promoCode: json['promoCode'],
      orderDate: DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
      shippedDate: json['shippedDate'] != null 
          ? DateTime.parse(json['shippedDate'])
          : null,
      deliveredDate: json['deliveredDate'] != null 
          ? DateTime.parse(json['deliveredDate'])
          : null,
      trackingNumber: json['trackingNumber'],
      shippingMethod: json['shippingMethod'] ?? 'Standard Shipping',
      statusHistory: (json['statusHistory'] as List<dynamic>?)
          ?.map((e) => OrderStatusUpdate.fromJson(e))
          .toList() ?? [],
      notes: json['notes'],
      isGift: json['isGift'] ?? false,
      giftMessage: json['giftMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'tax': tax,
      'discount': discount,
      'total': total,
      'status': status,
      'shippingAddress': shippingAddress.toJson(),
      'billingAddress': billingAddress?.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'promoCode': promoCode,
      'orderDate': orderDate.toIso8601String(),
      'shippedDate': shippedDate?.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'shippingMethod': shippingMethod,
      'statusHistory': statusHistory.map((e) => e.toJson()).toList(),
      'notes': notes,
      'isGift': isGift,
      'giftMessage': giftMessage,
    };
  }

  // Helper methods
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get canBeCancelled => status == 'Processing' || status == 'Confirmed';
  
  bool get canBeReturned => status == 'Delivered' && 
      DateTime.now().difference(deliveredDate!).inDays <= 30;
  
  bool get isDelivered => status == 'Delivered';
  
  bool get isShipped => status == 'Shipped' || status == 'Out for Delivery' || isDelivered;
  
  String get estimatedDeliveryDate {
    if (isDelivered) return 'Delivered';
    
    final orderDays = DateTime.now().difference(orderDate).inDays;
    final estimatedDays = shippingMethod.contains('Express') ? 5 : 
                         shippingMethod.contains('Next Day') ? 1 : 10;
    
    final remainingDays = estimatedDays - orderDays;
    if (remainingDays <= 0) return 'Soon';
    
    final deliveryDate = DateTime.now().add(Duration(days: remainingDays));
    return '${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}';
  }

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? subtotal,
    double? shippingCost,
    double? tax,
    double? discount,
    double? total,
    String? status,
    Address? shippingAddress,
    Address? billingAddress,
    PaymentMethod? paymentMethod,
    String? promoCode,
    DateTime? orderDate,
    DateTime? shippedDate,
    DateTime? deliveredDate,
    String? trackingNumber,
    String? shippingMethod,
    List<OrderStatusUpdate>? statusHistory,
    String? notes,
    bool? isGift,
    String? giftMessage,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      orderDate: orderDate ?? this.orderDate,
      shippedDate: shippedDate ?? this.shippedDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      statusHistory: statusHistory ?? this.statusHistory,
      notes: notes ?? this.notes,
      isGift: isGift ?? this.isGift,
      giftMessage: giftMessage ?? this.giftMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Order{id: $id, status: $status, total: $total, items: ${items.length}}';
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? originalPrice;
  final int quantity;
  final String selectedSize;
  final String selectedColor;
  final String category;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.originalPrice,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
    required this.category,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'] ?? '',
      selectedColor: json['selectedColor'] ?? '',
      category: json['category'] ?? '',
    );
  }

  factory OrderItem.fromCartItem(CartItem cartItem) {
    return OrderItem(
      productId: cartItem.product.id,
      productName: cartItem.product.name,
      productImage: cartItem.product.primaryImage,
      price: cartItem.product.price,
      originalPrice: cartItem.product.originalPrice,
      quantity: cartItem.quantity,
      selectedSize: cartItem.selectedSize,
      selectedColor: cartItem.selectedColor,
      category: cartItem.product.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'category': category,
    };
  }

  double get totalPrice => price * quantity;
  
  double get originalTotalPrice => (originalPrice ?? price) * quantity;
  
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}

class OrderStatusUpdate {
  final String status;
  final DateTime timestamp;
  final String? description;
  final String? location;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.description,
    this.location,
  });

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) {
    return OrderStatusUpdate(
      status: json['status'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      description: json['description'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'location': location,
    };
  }
}