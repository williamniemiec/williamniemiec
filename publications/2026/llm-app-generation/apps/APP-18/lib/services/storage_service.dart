import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import '../models/user.dart';

class StorageService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'access_token';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _searchHistoryKey = 'search_history';
  static const String _settingsKey = 'app_settings';

  // SharedPreferences instance
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // User data storage
  Future<void> saveCurrentUser(User user) async {
    final preferences = await prefs;
    await preferences.setString(_userKey, user.toJson().toString());
  }

  Future<User?> getCurrentUser() async {
    final preferences = await prefs;
    final userString = preferences.getString(_userKey);
    if (userString != null) {
      try {
        // Note: In a real app, you'd use proper JSON parsing
        // This is simplified for the example
        return null; // Would parse the user from JSON
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearCurrentUser() async {
    final preferences = await prefs;
    await preferences.remove(_userKey);
  }

  // Token storage
  Future<void> saveAccessToken(String token) async {
    final preferences = await prefs;
    await preferences.setString(_tokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final preferences = await prefs;
    return preferences.getString(_tokenKey);
  }

  Future<void> clearAccessToken() async {
    final preferences = await prefs;
    await preferences.remove(_tokenKey);
  }

  // Onboarding status
  Future<void> setOnboardingCompleted(bool completed) async {
    final preferences = await prefs;
    await preferences.setBool(_onboardingKey, completed);
  }

  Future<bool> isOnboardingCompleted() async {
    final preferences = await prefs;
    return preferences.getBool(_onboardingKey) ?? false;
  }

  // Search history
  Future<void> addSearchQuery(String query) async {
    final preferences = await prefs;
    final history = preferences.getStringList(_searchHistoryKey) ?? [];
    
    // Remove if already exists to avoid duplicates
    history.remove(query);
    // Add to the beginning
    history.insert(0, query);
    
    // Keep only the last 20 searches
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    await preferences.setStringList(_searchHistoryKey, history);
  }

  Future<List<String>> getSearchHistory() async {
    final preferences = await prefs;
    return preferences.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> clearSearchHistory() async {
    final preferences = await prefs;
    await preferences.remove(_searchHistoryKey);
  }

  // App settings
  Future<void> saveSetting(String key, dynamic value) async {
    final preferences = await prefs;
    if (value is String) {
      await preferences.setString('${_settingsKey}_$key', value);
    } else if (value is int) {
      await preferences.setInt('${_settingsKey}_$key', value);
    } else if (value is bool) {
      await preferences.setBool('${_settingsKey}_$key', value);
    } else if (value is double) {
      await preferences.setDouble('${_settingsKey}_$key', value);
    }
  }

  Future<T?> getSetting<T>(String key) async {
    final preferences = await prefs;
    final settingKey = '${_settingsKey}_$key';
    
    if (T == String) {
      return preferences.getString(settingKey) as T?;
    } else if (T == int) {
      return preferences.getInt(settingKey) as T?;
    } else if (T == bool) {
      return preferences.getBool(settingKey) as T?;
    } else if (T == double) {
      return preferences.getDouble(settingKey) as T?;
    }
    
    return null;
  }

  // File storage operations
  Future<Directory> get _localDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  Future<Directory> get _cacheDirectory async {
    return await getTemporaryDirectory();
  }

  // Image caching
  Future<String> cacheImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final cacheDir = await _cacheDirectory;
        final fileName = _generateFileName(imageUrl);
        final file = File(path.join(cacheDir.path, 'images', fileName));
        
        // Create directory if it doesn't exist
        await file.parent.create(recursive: true);
        
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      print('Error caching image: $e');
    }
    return imageUrl; // Return original URL if caching fails
  }

  Future<String?> getCachedImagePath(String imageUrl) async {
    try {
      final cacheDir = await _cacheDirectory;
      final fileName = _generateFileName(imageUrl);
      final file = File(path.join(cacheDir.path, 'images', fileName));
      
      if (await file.exists()) {
        return file.path;
      }
    } catch (e) {
      print('Error getting cached image: $e');
    }
    return null;
  }

  // Save image to local storage
  Future<String?> saveImageToLocal(File imageFile, {String? customName}) async {
    try {
      final localDir = await _localDirectory;
      final imagesDir = Directory(path.join(localDir.path, 'images'));
      await imagesDir.create(recursive: true);
      
      final fileName = customName ?? 
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final savedFile = File(path.join(imagesDir.path, fileName));
      
      await imageFile.copy(savedFile.path);
      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  // Save image from bytes
  Future<String?> saveImageFromBytes(Uint8List bytes, String fileName) async {
    try {
      final localDir = await _localDirectory;
      final imagesDir = Directory(path.join(localDir.path, 'images'));
      await imagesDir.create(recursive: true);
      
      final file = File(path.join(imagesDir.path, fileName));
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      print('Error saving image from bytes: $e');
      return null;
    }
  }

  // Delete cached image
  Future<void> deleteCachedImage(String imageUrl) async {
    try {
      final cacheDir = await _cacheDirectory;
      final fileName = _generateFileName(imageUrl);
      final file = File(path.join(cacheDir.path, 'images', fileName));
      
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting cached image: $e');
    }
  }

  // Clear all cached images
  Future<void> clearImageCache() async {
    try {
      final cacheDir = await _cacheDirectory;
      final imagesDir = Directory(path.join(cacheDir.path, 'images'));
      
      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing image cache: $e');
    }
  }

  // Get cache size
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await _cacheDirectory;
      final imagesDir = Directory(path.join(cacheDir.path, 'images'));
      
      if (await imagesDir.exists()) {
        int totalSize = 0;
        await for (final entity in imagesDir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
        return totalSize;
      }
    } catch (e) {
      print('Error getting cache size: $e');
    }
    return 0;
  }

  // Offline data storage
  Future<void> saveOfflineData(String key, Map<String, dynamic> data) async {
    try {
      final localDir = await _localDirectory;
      final offlineDir = Directory(path.join(localDir.path, 'offline'));
      await offlineDir.create(recursive: true);
      
      final file = File(path.join(offlineDir.path, '$key.json'));
      await file.writeAsString(data.toString()); // In real app, use jsonEncode
    } catch (e) {
      print('Error saving offline data: $e');
    }
  }

  Future<Map<String, dynamic>?> getOfflineData(String key) async {
    try {
      final localDir = await _localDirectory;
      final file = File(path.join(localDir.path, 'offline', '$key.json'));
      
      if (await file.exists()) {
        final content = await file.readAsString();
        // In real app, use jsonDecode
        return {}; // Would return parsed JSON
      }
    } catch (e) {
      print('Error getting offline data: $e');
    }
    return null;
  }

  // Clear all app data
  Future<void> clearAllData() async {
    try {
      final preferences = await prefs;
      await preferences.clear();
      
      final localDir = await _localDirectory;
      if (await localDir.exists()) {
        await localDir.delete(recursive: true);
      }
      
      await clearImageCache();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Helper methods
  String _generateFileName(String url) {
    // Generate a unique filename based on URL
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    final fileName = pathSegments.isNotEmpty ? pathSegments.last : 'image';
    final extension = path.extension(fileName).isEmpty ? '.jpg' : path.extension(fileName);
    final baseName = path.basenameWithoutExtension(fileName);
    final hash = url.hashCode.abs().toString();
    
    return '${baseName}_$hash$extension';
  }

  // Check if device has enough storage space
  Future<bool> hasEnoughStorage({int requiredBytes = 100 * 1024 * 1024}) async {
    try {
      final localDir = await _localDirectory;
      final stat = await localDir.stat();
      // This is a simplified check - in a real app you'd check available space
      return true;
    } catch (e) {
      print('Error checking storage: $e');
      return false;
    }
  }

  // Backup and restore functionality
  Future<Map<String, dynamic>> createBackup() async {
    final preferences = await prefs;
    final keys = preferences.getKeys();
    final backup = <String, dynamic>{};
    
    for (final key in keys) {
      final value = preferences.get(key);
      backup[key] = value;
    }
    
    return backup;
  }

  Future<void> restoreFromBackup(Map<String, dynamic> backup) async {
    final preferences = await prefs;
    
    for (final entry in backup.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is String) {
        await preferences.setString(key, value);
      } else if (value is int) {
        await preferences.setInt(key, value);
      } else if (value is bool) {
        await preferences.setBool(key, value);
      } else if (value is double) {
        await preferences.setDouble(key, value);
      } else if (value is List<String>) {
        await preferences.setStringList(key, value);
      }
    }
  }
}