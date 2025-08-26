import 'restaurant.dart';
import 'user.dart';

class Order {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantLogoUrl;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final Address deliveryAddress;
  final PaymentMethod paymentMethod;
  final String? couponCode;
  final String? specialInstructions;
  final DeliveryInfo? deliveryInfo;

  Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogoUrl,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
    this.estimatedDeliveryTime,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.couponCode,
    this.specialInstructions,
    this.deliveryInfo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      restaurantLogoUrl: json['restaurantLogoUrl'],
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      discount: json['discount'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : null,
      deliveryAddress: Address.fromJson(json['deliveryAddress']),
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      couponCode: json['couponCode'],
      specialInstructions: json['specialInstructions'],
      deliveryInfo: json['deliveryInfo'] != null
          ? DeliveryInfo.fromJson(json['deliveryInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantLogoUrl': restaurantLogoUrl,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'deliveryAddress': deliveryAddress.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'couponCode': couponCode,
      'specialInstructions': specialInstructions,
      'deliveryInfo': deliveryInfo?.toJson(),
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pedido realizado';
      case OrderStatus.confirmed:
        return 'Pedido confirmado';
      case OrderStatus.preparing:
        return 'Em preparo';
      case OrderStatus.ready:
        return 'Pronto para retirada';
      case OrderStatus.outForDelivery:
        return 'Saiu para entrega';
      case OrderStatus.delivered:
        return 'Entregue';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  bool get canBeCancelled {
    return status == OrderStatus.pending || status == OrderStatus.confirmed;
  }

  bool get isActive {
    return status != OrderStatus.delivered && status != OrderStatus.cancelled;
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
}

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final List<SelectedOption> selectedOptions;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    this.selectedOptions = const [],
    this.specialInstructions,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      unitPrice: json['unitPrice'].toDouble(),
      quantity: json['quantity'],
      selectedOptions: (json['selectedOptions'] as List<dynamic>?)
          ?.map((e) => SelectedOption.fromJson(e))
          .toList() ?? [],
      specialInstructions: json['specialInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'selectedOptions': selectedOptions.map((e) => e.toJson()).toList(),
      'specialInstructions': specialInstructions,
    };
  }

  double get totalPrice {
    double optionsPrice = selectedOptions.fold(0, (sum, option) => sum + option.price);
    return (unitPrice + optionsPrice) * quantity;
  }

  String get totalPriceText {
    return 'R\$ ${totalPrice.toStringAsFixed(2)}';
  }

  String get unitPriceText {
    return 'R\$ ${unitPrice.toStringAsFixed(2)}';
  }
}

class SelectedOption {
  final String optionId;
  final String optionName;
  final String itemId;
  final String itemName;
  final double price;

  SelectedOption({
    required this.optionId,
    required this.optionName,
    required this.itemId,
    required this.itemName,
    required this.price,
  });

  factory SelectedOption.fromJson(Map<String, dynamic> json) {
    return SelectedOption(
      optionId: json['optionId'],
      optionName: json['optionName'],
      itemId: json['itemId'],
      itemName: json['itemName'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': optionId,
      'optionName': optionName,
      'itemId': itemId,
      'itemName': itemName,
      'price': price,
    };
  }
}

class DeliveryInfo {
  final String courierId;
  final String courierName;
  final String? courierPhone;
  final double? courierLatitude;
  final double? courierLongitude;
  final String? vehicleType;
  final String? vehiclePlate;
  final DateTime? pickupTime;
  final List<OrderStatusUpdate> statusUpdates;

  DeliveryInfo({
    required this.courierId,
    required this.courierName,
    this.courierPhone,
    this.courierLatitude,
    this.courierLongitude,
    this.vehicleType,
    this.vehiclePlate,
    this.pickupTime,
    this.statusUpdates = const [],
  });

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryInfo(
      courierId: json['courierId'],
      courierName: json['courierName'],
      courierPhone: json['courierPhone'],
      courierLatitude: json['courierLatitude']?.toDouble(),
      courierLongitude: json['courierLongitude']?.toDouble(),
      vehicleType: json['vehicleType'],
      vehiclePlate: json['vehiclePlate'],
      pickupTime: json['pickupTime'] != null
          ? DateTime.parse(json['pickupTime'])
          : null,
      statusUpdates: (json['statusUpdates'] as List<dynamic>?)
          ?.map((e) => OrderStatusUpdate.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courierId': courierId,
      'courierName': courierName,
      'courierPhone': courierPhone,
      'courierLatitude': courierLatitude,
      'courierLongitude': courierLongitude,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'pickupTime': pickupTime?.toIso8601String(),
      'statusUpdates': statusUpdates.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String? message;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.message,
  });

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) {
    return OrderStatusUpdate(
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
    };
  }
}

class Coupon {
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType type;
  final double value;
  final double? minimumOrder;
  final DateTime expiryDate;
  final bool isUsed;
  final List<String>? applicableRestaurants;

  Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.minimumOrder,
    required this.expiryDate,
    this.isUsed = false,
    this.applicableRestaurants,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      description: json['description'],
      type: CouponType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      value: json['value'].toDouble(),
      minimumOrder: json['minimumOrder']?.toDouble(),
      expiryDate: DateTime.parse(json['expiryDate']),
      isUsed: json['isUsed'] ?? false,
      applicableRestaurants: json['applicableRestaurants'] != null
          ? List<String>.from(json['applicableRestaurants'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'value': value,
      'minimumOrder': minimumOrder,
      'expiryDate': expiryDate.toIso8601String(),
      'isUsed': isUsed,
      'applicableRestaurants': applicableRestaurants,
    };
  }

  bool get isValid {
    return !isUsed && DateTime.now().isBefore(expiryDate);
  }

  double calculateDiscount(double orderTotal) {
    if (!isValid) return 0;
    if (minimumOrder != null && orderTotal < minimumOrder!) return 0;

    switch (type) {
      case CouponType.percentage:
        return orderTotal * (value / 100);
      case CouponType.fixed:
        return value;
      case CouponType.freeDelivery:
        return 0; // Handled separately for delivery fee
    }
  }

  String get discountText {
    switch (type) {
      case CouponType.percentage:
        return '${value.toInt()}% OFF';
      case CouponType.fixed:
        return 'R\$ ${value.toStringAsFixed(2)} OFF';
      case CouponType.freeDelivery:
        return 'FRETE GRÁTIS';
    }
  }
}

enum CouponType {
  percentage,
  fixed,
  freeDelivery,
}