import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user.dart';
import '../../shared/models/cart.dart';
import '../../shared/models/product.dart';
import '../constants/app_constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  factory StorageService() => instance;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // User Management
  Future<void> saveUser(User user) async {
    await init();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(AppConstants.userDataKey, userJson);
  }

  Future<User?> getUser() async {
    await init();
    final userJson = prefs.getString(AppConstants.userDataKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> saveUserToken(String token) async {
    await init();
    await prefs.setString(AppConstants.userTokenKey, token);
  }

  Future<String?> getUserToken() async {
    await init();
    return prefs.getString(AppConstants.userTokenKey);
  }

  Future<void> clearUserData() async {
    await init();
    await prefs.remove(AppConstants.userDataKey);
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.cartKey);
    await prefs.remove(AppConstants.wishlistKey);
  }

  // Cart Management
  Future<void> saveCart(Cart cart) async {
    await init();
    final cartJson = jsonEncode(cart.toJson());
    await prefs.setString(AppConstants.cartKey, cartJson);
  }

  Future<Cart?> getCart() async {
    await init();
    final cartJson = prefs.getString(AppConstants.cartKey);
    if (cartJson != null) {
      try {
        final cartMap = jsonDecode(cartJson) as Map<String, dynamic>;
        return Cart.fromJson(cartMap);
      } catch (e) {
        print('Error parsing cart data: $e');
        return null;
      }
    }
    return null;
  }

  // Wishlist Management
  Future<void> saveWishlist(List<Product> wishlist) async {
    await init();
    final wishlistJson = jsonEncode(wishlist.map((p) => p.toJson()).toList());
    await prefs.setString(AppConstants.wishlistKey, wishlistJson);
  }

  Future<List<Product>> getWishlist() async {
    await init();
    final wishlistJson = prefs.getString(AppConstants.wishlistKey);
    if (wishlistJson != null) {
      try {
        final wishlistList = jsonDecode(wishlistJson) as List<dynamic>;
        return wishlistList.map((p) => Product.fromJson(p as Map<String, dynamic>)).toList();
      } catch (e) {
        print('Error parsing wishlist data: $e');
        return [];
      }
    }
    return [];
  }

  // Recent Searches Management
  Future<void> saveRecentSearches(List<String> searches) async {
    await init();
    await prefs.setStringList(AppConstants.recentSearchesKey, searches);
  }

  Future<List<String>> getRecentSearches() async {
    await init();
    return prefs.getStringList(AppConstants.recentSearchesKey) ?? [];
  }

  // Generic Storage Methods
  Future<void> setString(String key, String value) async {
    await init();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await init();
    return prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await init();
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await init();
    return prefs.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await init();
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await init();
    return prefs.getBool(key);
  }

  Future<void> setDouble(String key, double value) async {
    await init();
    await prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    await init();
    return prefs.getDouble(key);
  }

  Future<void> remove(String key) async {
    await init();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    await init();
    await prefs.clear();
  }

  Future<bool> containsKey(String key) async {
    await init();
    return prefs.containsKey(key);
  }

  Future<Set<String>> getKeys() async {
    await init();
    return prefs.getKeys();
  }
}