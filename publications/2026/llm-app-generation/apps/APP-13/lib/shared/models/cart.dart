import 'cookie.dart';
import 'order.dart';

class CartItem {
  final Cookie cookie;
  final int quantity;

  const CartItem({
    required this.cookie,
    required this.quantity,
  });

  double get totalPrice => cookie.price * quantity;

  CartItem copyWith({
    Cookie? cookie,
    int? quantity,
  }) {
    return CartItem(
      cookie: cookie ?? this.cookie,
      quantity: quantity ?? this.quantity,
    );
  }

  OrderItem toOrderItem() {
    return OrderItem(
      cookie: cookie,
      quantity: quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.cookie.id == cookie.id &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(cookie.id, quantity);

  @override
  String toString() {
    return 'CartItem(cookie: ${cookie.name}, quantity: $quantity)';
  }
}

enum BoxSize {
  fourPack(4, 'Four Pack'),
  sixPack(6, 'Six Pack'),
  twelvePack(12, 'Twelve Pack');

  const BoxSize(this.count, this.displayName);
  final int count;
  final String displayName;
}

class Cart {
  final List<CartItem> items;
  final BoxSize? selectedBoxSize;
  final String? promoCode;
  final double promoDiscount;

  const Cart({
    this.items = const [],
    this.selectedBoxSize,
    this.promoCode,
    this.promoDiscount = 0.0,
  });

  // Calculate totals
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get discount => promoDiscount;
  double get tax => subtotal * 0.08; // 8% tax rate
  double get total => subtotal - discount + tax;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  // Box size validation
  bool get isBoxSizeValid {
    if (selectedBoxSize == null) return totalItems == 0;
    return totalItems <= selectedBoxSize!.count;
  }

  int get remainingSlots {
    if (selectedBoxSize == null) return 0;
    return selectedBoxSize!.count - totalItems;
  }

  bool get canAddMore => selectedBoxSize != null && remainingSlots > 0;

  // Cart operations
  Cart addItem(Cookie cookie, {int quantity = 1}) {
    final existingIndex = items.indexWhere((item) => item.cookie.id == cookie.id);
    
    if (existingIndex >= 0) {
      // Update existing item
      final updatedItems = List<CartItem>.from(items);
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      
      return copyWith(items: updatedItems);
    } else {
      // Add new item
      return copyWith(
        items: [...items, CartItem(cookie: cookie, quantity: quantity)],
      );
    }
  }

  Cart removeItem(String cookieId) {
    return copyWith(
      items: items.where((item) => item.cookie.id != cookieId).toList(),
    );
  }

  Cart updateItemQuantity(String cookieId, int quantity) {
    if (quantity <= 0) {
      return removeItem(cookieId);
    }

    final updatedItems = items.map((item) {
      if (item.cookie.id == cookieId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return copyWith(items: updatedItems);
  }

  Cart clear() {
    return const Cart();
  }

  Cart setBoxSize(BoxSize boxSize) {
    return copyWith(selectedBoxSize: boxSize);
  }

  Cart applyPromoCode(String code, double discount) {
    return copyWith(
      promoCode: code,
      promoDiscount: discount,
    );
  }

  Cart removePromoCode() {
    return copyWith(
      promoCode: null,
      promoDiscount: 0.0,
    );
  }

  // Get item by cookie ID
  CartItem? getItem(String cookieId) {
    try {
      return items.firstWhere((item) => item.cookie.id == cookieId);
    } catch (e) {
      return null;
    }
  }

  // Get quantity for a specific cookie
  int getQuantity(String cookieId) {
    final item = getItem(cookieId);
    return item?.quantity ?? 0;
  }

  // Convert to order items
  List<OrderItem> toOrderItems() {
    return items.map((item) => item.toOrderItem()).toList();
  }

  Cart copyWith({
    List<CartItem>? items,
    BoxSize? selectedBoxSize,
    String? promoCode,
    double? promoDiscount,
  }) {
    return Cart(
      items: items ?? this.items,
      selectedBoxSize: selectedBoxSize ?? this.selectedBoxSize,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
        other.items.length == items.length &&
        other.selectedBoxSize == selectedBoxSize &&
        other.promoCode == promoCode &&
        other.promoDiscount == promoDiscount;
  }

  @override
  int get hashCode => Object.hash(
        items.length,
        selectedBoxSize,
        promoCode,
        promoDiscount,
      );

  @override
  String toString() {
    return 'Cart(items: ${items.length}, total: \$${total.toStringAsFixed(2)})';
  }
}