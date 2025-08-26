import 'package:flutter/foundation.dart';
import '../../../shared/models/order.dart';
import '../../../shared/models/restaurant.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  String? _restaurantId;
  String? _restaurantName;
  String? _restaurantLogoUrl;
  double _deliveryFee = 0.0;
  String? _appliedCouponCode;
  double _discount = 0.0;

  List<CartItem> get items => _items;
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  String? get restaurantLogoUrl => _restaurantLogoUrl;
  double get deliveryFee => _deliveryFee;
  String? get appliedCouponCode => _appliedCouponCode;
  double get discount => _discount;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal + _deliveryFee - _discount;

  void addItem(Product product, Restaurant restaurant, {
    List<SelectedOption> selectedOptions = const [],
    String? specialInstructions,
    int quantity = 1,
  }) {
    // Check if cart is empty or from same restaurant
    if (_items.isEmpty) {
      _restaurantId = restaurant.id;
      _restaurantName = restaurant.name;
      _restaurantLogoUrl = restaurant.logoUrl;
      _deliveryFee = restaurant.deliveryFee;
    } else if (_restaurantId != restaurant.id) {
      // Different restaurant - clear cart and start fresh
      clearCart();
      _restaurantId = restaurant.id;
      _restaurantName = restaurant.name;
      _restaurantLogoUrl = restaurant.logoUrl;
      _deliveryFee = restaurant.deliveryFee;
    }

    // Check if item with same options already exists
    final existingItemIndex = _items.indexWhere((item) =>
        item.productId == product.id &&
        _areOptionsEqual(item.selectedOptions, selectedOptions) &&
        item.specialInstructions == specialInstructions);

    if (existingItemIndex >= 0) {
      // Update quantity of existing item
      _items[existingItemIndex] = CartItem(
        id: _items[existingItemIndex].id,
        productId: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        unitPrice: product.price,
        quantity: _items[existingItemIndex].quantity + quantity,
        selectedOptions: selectedOptions,
        specialInstructions: specialInstructions,
      );
    } else {
      // Add new item
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        unitPrice: product.price,
        quantity: quantity,
        selectedOptions: selectedOptions,
        specialInstructions: specialInstructions,
      );
      _items.add(cartItem);
    }

    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    
    if (_items.isEmpty) {
      clearCart();
    }
    
    notifyListeners();
  }

  void updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex >= 0) {
      _items[itemIndex] = CartItem(
        id: _items[itemIndex].id,
        productId: _items[itemIndex].productId,
        name: _items[itemIndex].name,
        imageUrl: _items[itemIndex].imageUrl,
        unitPrice: _items[itemIndex].unitPrice,
        quantity: quantity,
        selectedOptions: _items[itemIndex].selectedOptions,
        specialInstructions: _items[itemIndex].specialInstructions,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    _restaurantLogoUrl = null;
    _deliveryFee = 0.0;
    _appliedCouponCode = null;
    _discount = 0.0;
    notifyListeners();
  }

  void applyCoupon(Coupon coupon) {
    if (!coupon.isValid) return;

    // Check if coupon is applicable to current restaurant
    if (coupon.applicableRestaurants != null &&
        !coupon.applicableRestaurants!.contains(_restaurantId)) {
      return;
    }

    // Check minimum order requirement
    if (coupon.minimumOrder != null && subtotal < coupon.minimumOrder!) {
      return;
    }

    _appliedCouponCode = coupon.code;
    
    switch (coupon.type) {
      case CouponType.percentage:
        _discount = subtotal * (coupon.value / 100);
        break;
      case CouponType.fixed:
        _discount = coupon.value;
        break;
      case CouponType.freeDelivery:
        _discount = _deliveryFee;
        break;
    }

    notifyListeners();
  }

  void removeCoupon() {
    _appliedCouponCode = null;
    _discount = 0.0;
    notifyListeners();
  }

  bool _areOptionsEqual(List<SelectedOption> options1, List<SelectedOption> options2) {
    if (options1.length != options2.length) return false;
    
    for (int i = 0; i < options1.length; i++) {
      final option1 = options1[i];
      final option2 = options2[i];
      
      if (option1.optionId != option2.optionId ||
          option1.itemId != option2.itemId) {
        return false;
      }
    }
    
    return true;
  }

  // Get cart summary for checkout
  Map<String, dynamic> getCartSummary() {
    return {
      'restaurantId': _restaurantId,
      'restaurantName': _restaurantName,
      'restaurantLogoUrl': _restaurantLogoUrl,
      'items': _items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': _deliveryFee,
      'discount': _discount,
      'total': total,
      'appliedCouponCode': _appliedCouponCode,
      'itemCount': itemCount,
    };
  }
}