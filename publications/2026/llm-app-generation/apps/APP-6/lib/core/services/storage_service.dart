import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  Box? _hiveBox;

  // Initialize storage services
  Future<void> initialize() async {
    try {
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();
      
      // Initialize Hive
      await Hive.initFlutter();
      _hiveBox = await Hive.openBox('canva_app_storage');
      
      if (kDebugMode) {
        debugPrint('Storage services initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize storage services: $e');
      }
      rethrow;
    }
  }

  // SharedPreferences methods (for simple key-value storage)
  
  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set string: $e');
      }
      return false;
    }
  }

  String? getString(String key, [String? defaultValue]) {
    try {
      return _prefs?.getString(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get string: $e');
      }
      return defaultValue;
    }
  }

  // Integer operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs?.setInt(key, value) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set int: $e');
      }
      return false;
    }
  }

  int? getInt(String key, [int? defaultValue]) {
    try {
      return _prefs?.getInt(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get int: $e');
      }
      return defaultValue;
    }
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs?.setBool(key, value) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set bool: $e');
      }
      return false;
    }
  }

  bool? getBool(String key, [bool? defaultValue]) {
    try {
      return _prefs?.getBool(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get bool: $e');
      }
      return defaultValue;
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs?.setDouble(key, value) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set double: $e');
      }
      return false;
    }
  }

  double? getDouble(String key, [double? defaultValue]) {
    try {
      return _prefs?.getDouble(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get double: $e');
      }
      return defaultValue;
    }
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs?.setStringList(key, value) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set string list: $e');
      }
      return false;
    }
  }

  List<String>? getStringList(String key, [List<String>? defaultValue]) {
    try {
      return _prefs?.getStringList(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get string list: $e');
      }
      return defaultValue;
    }
  }

  // JSON operations (for complex objects)
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set JSON: $e');
      }
      return false;
    }
  }

  Map<String, dynamic>? getJson(String key, [Map<String, dynamic>? defaultValue]) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return defaultValue;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get JSON: $e');
      }
      return defaultValue;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    try {
      return await _prefs?.remove(key) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to remove key: $e');
      }
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to clear preferences: $e');
      }
      return false;
    }
  }

  bool containsKey(String key) {
    try {
      return _prefs?.containsKey(key) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to check key existence: $e');
      }
      return false;
    }
  }

  Set<String> getKeys() {
    try {
      return _prefs?.getKeys() ?? <String>{};
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get keys: $e');
      }
      return <String>{};
    }
  }

  // Hive methods (for complex data storage and caching)
  
  Future<void> hiveSet(String key, dynamic value) async {
    try {
      await _hiveBox?.put(key, value);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set Hive value: $e');
      }
      rethrow;
    }
  }

  T? hiveGet<T>(String key, [T? defaultValue]) {
    try {
      return _hiveBox?.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get Hive value: $e');
      }
      return defaultValue;
    }
  }

  Future<void> hiveDelete(String key) async {
    try {
      await _hiveBox?.delete(key);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to delete Hive key: $e');
      }
      rethrow;
    }
  }

  Future<void> hiveClear() async {
    try {
      await _hiveBox?.clear();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to clear Hive box: $e');
      }
      rethrow;
    }
  }

  bool hiveContainsKey(String key) {
    try {
      return _hiveBox?.containsKey(key) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to check Hive key existence: $e');
      }
      return false;
    }
  }

  List<String> hiveGetKeys() {
    try {
      return _hiveBox?.keys.cast<String>().toList() ?? [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get Hive keys: $e');
      }
      return [];
    }
  }

  int hiveLength() {
    try {
      return _hiveBox?.length ?? 0;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get Hive length: $e');
      }
      return 0;
    }
  }

  // Cache management
  Future<void> setCacheWithExpiry(String key, dynamic value, Duration expiry) async {
    try {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      final cacheData = {
        'value': value,
        'expiry': expiryTime,
      };
      await hiveSet(key, cacheData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set cache with expiry: $e');
      }
      rethrow;
    }
  }

  T? getCacheWithExpiry<T>(String key) {
    try {
      final cacheData = hiveGet<Map<dynamic, dynamic>>(key);
      if (cacheData == null) return null;

      final expiryTime = cacheData['expiry'] as int?;
      if (expiryTime == null) return null;

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expiryTime) {
        // Cache expired, remove it
        hiveDelete(key);
        return null;
      }

      return cacheData['value'] as T?;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get cache with expiry: $e');
      }
      return null;
    }
  }

  // Cleanup expired cache entries
  Future<void> cleanupExpiredCache() async {
    try {
      final keys = hiveGetKeys();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final key in keys) {
        final cacheData = hiveGet<Map<dynamic, dynamic>>(key);
        if (cacheData != null && cacheData.containsKey('expiry')) {
          final expiryTime = cacheData['expiry'] as int?;
          if (expiryTime != null && now > expiryTime) {
            await hiveDelete(key);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to cleanup expired cache: $e');
      }
    }
  }

  // Close storage services
  Future<void> close() async {
    try {
      await _hiveBox?.close();
      await Hive.close();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to close storage services: $e');
      }
    }
  }
}

// Storage keys constants
class StorageKeys {
  // User preferences
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String userProfile = 'user_profile';
  static const String isFirstLaunch = 'is_first_launch';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';

  // App settings
  static const String autoSave = 'auto_save';
  static const String gridEnabled = 'grid_enabled';
  static const String snapToGrid = 'snap_to_grid';
  static const String showRulers = 'show_rulers';
  static const String defaultExportFormat = 'default_export_format';
  static const String defaultExportQuality = 'default_export_quality';

  // Recent data
  static const String recentDesigns = 'recent_designs';
  static const String recentTemplates = 'recent_templates';
  static const String recentColors = 'recent_colors';
  static const String recentFonts = 'recent_fonts';

  // Cache keys
  static const String templatesCache = 'templates_cache';
  static const String assetsCache = 'assets_cache';
  static const String userDesignsCache = 'user_designs_cache';

  // Subscription
  static const String subscriptionStatus = 'subscription_status';
  static const String subscriptionExpiry = 'subscription_expiry';
  static const String usageStats = 'usage_stats';
}