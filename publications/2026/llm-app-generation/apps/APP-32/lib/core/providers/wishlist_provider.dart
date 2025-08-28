import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../shared/models/product.dart';
import '../constants/app_constants.dart';

class WishlistProvider extends ChangeNotifier {
  List<Product> _wishlistItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _wishlistItems.length;
  bool get isEmpty => _wishlistItems.isEmpty;
  bool get isNotEmpty => _wishlistItems.isNotEmpty;

  WishlistProvider() {
    _loadWishlistFromStorage();
  }

  // Load wishlist from local storage
  Future<void> _loadWishlistFromStorage() async {
    try {
      final wishlistBox = Hive.box('wishlist');
      final wishlistData = wishlistBox.get(AppConstants.wishlistDataKey);
      
      if (wishlistData != null) {
        final List<dynamic> itemsList = wishlistData;
        _wishlistItems = itemsList
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist from storage: $e');
    }
  }

  // Save wishlist to local storage
  Future<void> _saveWishlistToStorage() async {
    try {
      final wishlistBox = Hive.box('wishlist');
      final wishlistData = _wishlistItems.map((item) => item.toJson()).toList();
      await wishlistBox.put(AppConstants.wishlistDataKey, wishlistData);
    } catch (e) {
      debugPrint('Error saving wishlist to storage: $e');
    }
  }

  // Add product to wishlist
  Future<void> addToWishlist(Product product) async {
    try {
      _errorMessage = null;

      // Check if product is already in wishlist
      if (!isInWishlist(product.id)) {
        _wishlistItems.add(product);
        await _saveWishlistToStorage();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to add item to wishlist';
      notifyListeners();
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      _wishlistItems.removeWhere((item) => item.id == productId);
      await _saveWishlistToStorage();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to remove item from wishlist';
      notifyListeners();
    }
  }

  // Toggle product in wishlist
  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  // Get wishlist item by product ID
  Product? getWishlistItem(String productId) {
    try {
      return _wishlistItems.firstWhere((item) => item.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Clear entire wishlist
  Future<void> clearWishlist() async {
    try {
      _wishlistItems.clear();
      await _saveWishlistToStorage();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear wishlist';
      notifyListeners();
    }
  }

  // Get wishlist items by category
  List<Product> getItemsByCategory(String category) {
    return _wishlistItems.where((item) => item.category == category).toList();
  }

  // Get wishlist items on sale
  List<Product> getItemsOnSale() {
    return _wishlistItems.where((item) => item.isOnSale).toList();
  }

  // Get wishlist items by price range
  List<Product> getItemsByPriceRange(double minPrice, double maxPrice) {
    return _wishlistItems
        .where((item) => item.price >= minPrice && item.price <= maxPrice)
        .toList();
  }

  // Sort wishlist items
  List<Product> getSortedItems(String sortBy) {
    final sortedItems = List<Product>.from(_wishlistItems);
    
    switch (sortBy) {
      case 'Price: Low to High':
        sortedItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sortedItems.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Newest':
        sortedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Name A-Z':
        sortedItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name Z-A':
        sortedItems.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Rating':
        sortedItems.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        break;
    }
    
    return sortedItems;
  }

  // Get total value of wishlist
  double get totalValue {
    return _wishlistItems.fold(0.0, (sum, item) => sum + item.price);
  }

  // Get total savings if all items were purchased
  double get totalSavings {
    return _wishlistItems.fold(0.0, (sum, item) {
      if (item.originalPrice != null) {
        return sum + (item.originalPrice! - item.price);
      }
      return sum;
    });
  }

  // Get categories in wishlist
  List<String> get categoriesInWishlist {
    return _wishlistItems.map((item) => item.category).toSet().toList();
  }

  // Get brands in wishlist
  List<String> get brandsInWishlist {
    return _wishlistItems.map((item) => item.brand).toSet().toList();
  }

  // Move multiple items to cart (would need cart provider reference)
  Future<void> moveSelectedToCart(List<String> productIds) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate moving to cart
      await Future.delayed(const Duration(milliseconds: 500));

      // Remove moved items from wishlist
      _wishlistItems.removeWhere((item) => productIds.contains(item.id));
      await _saveWishlistToStorage();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to move items to cart';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Share wishlist (would generate a shareable link)
  String generateShareableWishlist() {
    // In a real app, this would generate a shareable link
    final productIds = _wishlistItems.map((item) => item.id).join(',');
    return 'https://shein.com/wishlist/shared?items=$productIds';
  }

  // Import wishlist from shared link
  Future<void> importSharedWishlist(String shareableLink) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate importing wishlist
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would parse the link and fetch products
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to import wishlist';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get recently added items
  List<Product> getRecentlyAdded({int limit = 5}) {
    final sortedItems = List<Product>.from(_wishlistItems);
    sortedItems.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedItems.take(limit).toList();
  }

  // Search within wishlist
  List<Product> searchWishlist(String query) {
    if (query.isEmpty) return _wishlistItems;
    
    final lowercaseQuery = query.toLowerCase();
    return _wishlistItems.where((product) =>
        product.name.toLowerCase().contains(lowercaseQuery) ||
        product.description.toLowerCase().contains(lowercaseQuery) ||
        product.category.toLowerCase().contains(lowercaseQuery) ||
        product.brand.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get wishlist statistics
  Map<String, dynamic> getWishlistStats() {
    final stats = <String, dynamic>{};
    
    stats['totalItems'] = itemCount;
    stats['totalValue'] = totalValue;
    stats['totalSavings'] = totalSavings;
    stats['categoriesCount'] = categoriesInWishlist.length;
    stats['brandsCount'] = brandsInWishlist.length;
    stats['itemsOnSale'] = getItemsOnSale().length;
    
    // Most common category
    if (_wishlistItems.isNotEmpty) {
      final categoryCount = <String, int>{};
      for (final item in _wishlistItems) {
        categoryCount[item.category] = (categoryCount[item.category] ?? 0) + 1;
      }
      final mostCommonCategory = categoryCount.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      stats['mostCommonCategory'] = mostCommonCategory.key;
    }
    
    return stats;
  }
}