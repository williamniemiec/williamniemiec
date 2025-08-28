import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final String selectedSize;
  final String selectedColor;
  final int quantity;
  final DateTime addedAt;
  final DateTime updatedAt;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.addedAt,
    required this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      selectedSize: json['selectedSize'] ?? '',
      selectedColor: json['selectedColor'] ?? '',
      quantity: json['quantity'] ?? 1,
      addedAt: DateTime.parse(json['addedAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    String? id,
    Product? product,
    String? selectedSize,
    String? selectedColor,
    int? quantity,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  double get totalPrice => product.price * quantity;
  
  double get originalTotalPrice => (product.originalPrice ?? product.price) * quantity;
  
  double get totalSavings => originalTotalPrice - totalPrice;
  
  bool get hasDiscount => product.hasDiscount;
  
  String get displayName => '${product.name} - $selectedColor, $selectedSize';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CartItem{id: $id, product: ${product.name}, quantity: $quantity, size: $selectedSize, color: $selectedColor}';
  }
}