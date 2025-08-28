import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final Map<String, String> selectedVariants;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.selectedVariants,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedVariants: Map<String, String>.from(json['selectedVariants'] ?? {}),
      addedAt: DateTime.parse(json['addedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'selectedVariants': selectedVariants,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    Map<String, String>? selectedVariants,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class Cart {
  final List<CartItem> items;
  final DateTime updatedAt;

  Cart({
    required this.items,
    required this.updatedAt,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get shipping => subtotal >= 35 ? 0 : 5.99; // Free shipping over $35
  
  double get tax => subtotal * 0.08; // 8% tax
  
  double get total => subtotal + shipping + tax;
  
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get isEmpty => items.isEmpty;
  
  bool get isNotEmpty => items.isNotEmpty;

  factory Cart.empty() {
    return Cart(
      items: [],
      updatedAt: DateTime.now(),
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Cart addItem(CartItem item) {
    final existingIndex = items.indexWhere(
      (existing) => 
        existing.product.id == item.product.id &&
        _mapsEqual(existing.selectedVariants, item.selectedVariants),
    );

    List<CartItem> newItems;
    if (existingIndex >= 0) {
      newItems = List.from(items);
      newItems[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + item.quantity,
      );
    } else {
      newItems = [...items, item];
    }

    return Cart(
      items: newItems,
      updatedAt: DateTime.now(),
    );
  }

  Cart removeItem(String itemId) {
    return Cart(
      items: items.where((item) => item.id != itemId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  Cart updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      return removeItem(itemId);
    }

    final newItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return Cart(
      items: newItems,
      updatedAt: DateTime.now(),
    );
  }

  Cart clear() {
    return Cart.empty();
  }

  bool _mapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }
}