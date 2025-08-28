import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/cart_item.dart';
import '../../shared/models/product.dart';
import '../constants/app_constants.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Uuid _uuid = const Uuid();

  // Getters
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _items.length;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  CartProvider() {
    _loadCartFromStorage();
  }

  // Calculate totals
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get originalSubtotal => _items.fold(0.0, (sum, item) => sum + item.originalTotalPrice);
  
  double get totalSavings => originalSubtotal - subtotal;
  
  double get shippingCost {
    // Free shipping over $35
    return subtotal >= 35.0 ? 0.0 : 5.99;
  }
  
  double get tax => subtotal * 0.08; // 8% tax
  
  double get total => subtotal + shippingCost + tax;

  // Load cart from local storage
  Future<void> _loadCartFromStorage() async {
    try {
      final cartBox = Hive.box('cart');
      final cartData = cartBox.get(AppConstants.cartDataKey);
      
      if (cartData != null) {
        final List<dynamic> itemsList = cartData;
        _items = itemsList
            .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart from storage: $e');
    }
  }

  // Save cart to local storage
  Future<void> _saveCartToStorage() async {
    try {
      final cartBox = Hive.box('cart');
      final cartData = _items.map((item) => item.toJson()).toList();
      await cartBox.put(AppConstants.cartDataKey, cartData);
    } catch (e) {
      debugPrint('Error saving cart to storage: $e');
    }
  }

  // Add item to cart
  Future<void> addToCart({
    required Product product,
    required String selectedSize,
    required String selectedColor,
    int quantity = 1,
  }) async {
    try {
      _errorMessage = null;

      // Check if item already exists in cart
      final existingItemIndex = _items.indexWhere((item) =>
          item.product.id == product.id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor);

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = _items[existingItemIndex];
        final newQuantity = existingItem.quantity + quantity;
        
        _items[existingItemIndex] = existingItem.copyWith(
          quantity: newQuantity,
          updatedAt: DateTime.now(),
        );
      } else {
        // Add new item to cart
        final cartItem = CartItem(
          id: _uuid.v4(),
          product: product,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
          quantity: quantity,
          addedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        _items.add(cartItem);
      }

      await _saveCartToStorage();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add item to cart';
      notifyListeners();
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      _items.removeWhere((item) => item.id == itemId);
      await _saveCartToStorage();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to remove item from cart';
      notifyListeners();
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(itemId);
        return;
      }

      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _items[itemIndex] = _items[itemIndex].copyWith(
          quantity: newQuantity,
          updatedAt: DateTime.now(),
        );
        
        await _saveCartToStorage();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update item quantity';
      notifyListeners();
    }
  }

  // Increment item quantity
  Future<void> incrementQuantity(String itemId) async {
    final item = _items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity + 1);
  }

  // Decrement item quantity
  Future<void> decrementQuantity(String itemId) async {
    final item = _items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity - 1);
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      _items.clear();
      await _saveCartToStorage();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear cart';
      notifyListeners();
    }
  }

  // Check if product is in cart
  bool isInCart(String productId, {String? size, String? color}) {
    return _items.any((item) =>
        item.product.id == productId &&
        (size == null || item.selectedSize == size) &&
        (color == null || item.selectedColor == color));
  }

  // Get cart item by product
  CartItem? getCartItem(String productId, {String? size, String? color}) {
    try {
      return _items.firstWhere((item) =>
          item.product.id == productId &&
          (size == null || item.selectedSize == size) &&
          (color == null || item.selectedColor == color));
    } catch (e) {
      return null;
    }
  }

  // Get quantity of specific product in cart
  int getProductQuantity(String productId, {String? size, String? color}) {
    final item = getCartItem(productId, size: size, color: color);
    return item?.quantity ?? 0;
  }

  // Apply promo code
  double _promoDiscount = 0.0;
  String? _appliedPromoCode;
  
  double get promoDiscount => _promoDiscount;
  String? get appliedPromoCode => _appliedPromoCode;
  double get finalTotal => total - _promoDiscount;

  Future<bool> applyPromoCode(String promoCode) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock promo code validation
      final Map<String, double> validPromoCodes = {
        'SAVE10': 0.10, // 10% off
        'SAVE20': 0.20, // 20% off
        'WELCOME': 0.15, // 15% off
        'FLASH50': 0.50, // 50% off
      };

      if (validPromoCodes.containsKey(promoCode.toUpperCase())) {
        final discountPercentage = validPromoCodes[promoCode.toUpperCase()]!;
        _promoDiscount = subtotal * discountPercentage;
        _appliedPromoCode = promoCode.toUpperCase();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid promo code';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to apply promo code';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Remove promo code
  void removePromoCode() {
    _promoDiscount = 0.0;
    _appliedPromoCode = null;
    notifyListeners();
  }

  // Get items by category
  List<CartItem> getItemsByCategory(String category) {
    return _items.where((item) => item.product.category == category).toList();
  }

  // Get recommended products based on cart items
  List<String> getRecommendedCategories() {
    final categories = _items.map((item) => item.product.category).toSet().toList();
    return categories;
  }

  // Calculate savings
  Map<String, double> getSavingsBreakdown() {
    return {
      'itemDiscounts': totalSavings,
      'promoDiscount': _promoDiscount,
      'shippingDiscount': subtotal >= 35.0 ? 5.99 : 0.0,
      'totalSavings': totalSavings + _promoDiscount + (subtotal >= 35.0 ? 5.99 : 0.0),
    };
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Move item to wishlist (if wishlist provider is available)
  Future<void> moveToWishlist(String itemId) async {
    try {
      final item = _items.firstWhere((item) => item.id == itemId);
      // This would typically call wishlist provider to add the product
      await removeFromCart(itemId);
    } catch (e) {
      _errorMessage = 'Failed to move item to wishlist';
      notifyListeners();
    }
  }

  // Save for later
  List<CartItem> _savedItems = [];
  List<CartItem> get savedItems => _savedItems;

  Future<void> saveForLater(String itemId) async {
    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final item = _items.removeAt(itemIndex);
        _savedItems.add(item);
        await _saveCartToStorage();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to save item for later';
      notifyListeners();
    }
  }

  Future<void> moveBackToCart(String itemId) async {
    try {
      final itemIndex = _savedItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final item = _savedItems.removeAt(itemIndex);
        _items.add(item.copyWith(updatedAt: DateTime.now()));
        await _saveCartToStorage();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to move item back to cart';
      notifyListeners();
    }
  }
}