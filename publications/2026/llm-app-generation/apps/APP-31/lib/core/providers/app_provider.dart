import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../shared/models/cart.dart';
import '../../shared/models/product.dart';
import '../../shared/models/order.dart';
import '../../shared/models/coupon.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  User? _currentUser;
  Cart _cart = Cart.empty();
  List<Product> _wishlist = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  Cart get cart => _cart;
  List<Product> get wishlist => _wishlist;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // Cart getters
  int get cartItemCount => _cart.itemCount;
  double get cartTotal => _cart.total;
  bool get isCartEmpty => _cart.isEmpty;

  final StorageService _storageService = StorageService();

  AppProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setLoading(true);
    try {
      await _loadCart();
      await _loadWishlist();
      await _loadRecentSearches();
      await _loadUser();
    } catch (e) {
      setError('Failed to load app data: $e');
    } finally {
      setLoading(false);
    }
  }

  // Loading and Error Management
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // User Management
  Future<void> setUser(User user) async {
    _currentUser = user;
    await _storageService.saveUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _cart = Cart.empty();
    _wishlist.clear();
    await _storageService.clearUserData();
    notifyListeners();
  }

  Future<void> _loadUser() async {
    final user = await _storageService.getUser();
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  // Cart Management
  Future<void> addToCart(Product product, int quantity, Map<String, String> selectedVariants) async {
    final cartItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      quantity: quantity,
      selectedVariants: selectedVariants,
      addedAt: DateTime.now(),
    );

    _cart = _cart.addItem(cartItem);
    await _saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(String itemId) async {
    _cart = _cart.removeItem(itemId);
    await _saveCart();
    notifyListeners();
  }

  Future<void> updateCartItemQuantity(String itemId, int quantity) async {
    _cart = _cart.updateQuantity(itemId, quantity);
    await _saveCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cart = Cart.empty();
    await _saveCart();
    notifyListeners();
  }

  Future<void> _loadCart() async {
    final cart = await _storageService.getCart();
    if (cart != null) {
      _cart = cart;
    }
  }

  Future<void> _saveCart() async {
    await _storageService.saveCart(_cart);
  }

  // Wishlist Management
  Future<void> addToWishlist(Product product) async {
    if (!_wishlist.any((p) => p.id == product.id)) {
      _wishlist.add(product);
      await _saveWishlist();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    _wishlist.removeWhere((product) => product.id == productId);
    await _saveWishlist();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  Future<void> _loadWishlist() async {
    final wishlist = await _storageService.getWishlist();
    _wishlist = wishlist;
  }

  Future<void> _saveWishlist() async {
    await _storageService.saveWishlist(_wishlist);
  }

  // Search Management
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }
    
    await _saveRecentSearches();
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
    await _saveRecentSearches();
    notifyListeners();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _storageService.getRecentSearches();
    _recentSearches = searches;
  }

  Future<void> _saveRecentSearches() async {
    await _storageService.saveRecentSearches(_recentSearches);
  }

  // User Credits and Coupons
  Future<void> addCredits(double amount) async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: _currentUser!.name,
        profileImage: _currentUser!.profileImage,
        phoneNumber: _currentUser!.phoneNumber,
        addresses: _currentUser!.addresses,
        credits: _currentUser!.credits + amount,
        coupons: _currentUser!.coupons,
        totalOrders: _currentUser!.totalOrders,
        totalSpent: _currentUser!.totalSpent,
        joinDate: _currentUser!.joinDate,
        preferences: _currentUser!.preferences,
      );
      await setUser(updatedUser);
    }
  }

  Future<void> addCoupon(Coupon coupon) async {
    if (_currentUser != null) {
      final updatedCoupons = [..._currentUser!.coupons, coupon];
      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: _currentUser!.name,
        profileImage: _currentUser!.profileImage,
        phoneNumber: _currentUser!.phoneNumber,
        addresses: _currentUser!.addresses,
        credits: _currentUser!.credits,
        coupons: updatedCoupons,
        totalOrders: _currentUser!.totalOrders,
        totalSpent: _currentUser!.totalSpent,
        joinDate: _currentUser!.joinDate,
        preferences: _currentUser!.preferences,
      );
      await setUser(updatedUser);
    }
  }

  // Order Management
  Future<void> updateOrderStats(double orderTotal) async {
    if (_currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: _currentUser!.name,
        profileImage: _currentUser!.profileImage,
        phoneNumber: _currentUser!.phoneNumber,
        addresses: _currentUser!.addresses,
        credits: _currentUser!.credits,
        coupons: _currentUser!.coupons,
        totalOrders: _currentUser!.totalOrders + 1,
        totalSpent: _currentUser!.totalSpent + orderTotal,
        joinDate: _currentUser!.joinDate,
        preferences: _currentUser!.preferences,
      );
      await setUser(updatedUser);
    }
  }
}