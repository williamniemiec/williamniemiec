import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // App Settings
  Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await prefs.setBool(AppConstants.keyFirstLaunch, isFirstLaunch);
  }

  bool getFirstLaunch() {
    return prefs.getBool(AppConstants.keyFirstLaunch) ?? true;
  }

  // User Preferences
  Future<bool> setSoundEnabled(bool enabled) async {
    return await prefs.setBool('sound_enabled', enabled);
  }

  bool getSoundEnabled() {
    return prefs.getBool('sound_enabled') ?? true;
  }

  Future<bool> setVibrationEnabled(bool enabled) async {
    return await prefs.setBool('vibration_enabled', enabled);
  }

  bool getVibrationEnabled() {
    return prefs.getBool('vibration_enabled') ?? true;
  }

  Future<bool> setAutoSaveEnabled(bool enabled) async {
    return await prefs.setBool('auto_save_enabled', enabled);
  }

  bool getAutoSaveEnabled() {
    return prefs.getBool('auto_save_enabled') ?? true;
  }

  Future<bool> setHintsEnabled(bool enabled) async {
    return await prefs.setBool('hints_enabled', enabled);
  }

  bool getHintsEnabled() {
    return prefs.getBool('hints_enabled') ?? true;
  }

  // Theme Settings
  Future<bool> setDarkMode(bool enabled) async {
    return await prefs.setBool('dark_mode', enabled);
  }

  bool getDarkMode() {
    return prefs.getBool('dark_mode') ?? false;
  }

  // Last Selected Category
  Future<bool> setLastSelectedCategory(String category) async {
    return await prefs.setString('last_selected_category', category);
  }

  String getLastSelectedCategory() {
    return prefs.getString('last_selected_category') ?? 'Featured';
  }

  // Recently Viewed Pages
  Future<bool> addRecentlyViewed(String pageId) async {
    final recentlyViewed = getRecentlyViewed();
    recentlyViewed.remove(pageId); // Remove if already exists
    recentlyViewed.insert(0, pageId); // Add to beginning
    
    // Keep only last 10 items
    if (recentlyViewed.length > 10) {
      recentlyViewed.removeRange(10, recentlyViewed.length);
    }
    
    return await prefs.setStringList('recently_viewed', recentlyViewed);
  }

  List<String> getRecentlyViewed() {
    return prefs.getStringList('recently_viewed') ?? [];
  }

  // Favorites
  Future<bool> addToFavorites(String pageId) async {
    final favorites = getFavorites();
    if (!favorites.contains(pageId)) {
      favorites.add(pageId);
      return await prefs.setStringList('favorites', favorites);
    }
    return true;
  }

  Future<bool> removeFromFavorites(String pageId) async {
    final favorites = getFavorites();
    favorites.remove(pageId);
    return await prefs.setStringList('favorites', favorites);
  }

  List<String> getFavorites() {
    return prefs.getStringList('favorites') ?? [];
  }

  bool isFavorite(String pageId) {
    return getFavorites().contains(pageId);
  }

  // Statistics
  Future<bool> incrementCompletedPages() async {
    final current = getCompletedPagesCount();
    return await prefs.setInt('completed_pages_count', current + 1);
  }

  int getCompletedPagesCount() {
    return prefs.getInt('completed_pages_count') ?? 0;
  }

  Future<bool> addColoringTime(int minutes) async {
    final current = getTotalColoringTime();
    return await prefs.setInt('total_coloring_time', current + minutes);
  }

  int getTotalColoringTime() {
    return prefs.getInt('total_coloring_time') ?? 0;
  }

  // Session Data
  Future<bool> setCurrentColoringSession(Map<String, dynamic> sessionData) async {
    return await prefs.setString('current_session', jsonEncode(sessionData));
  }

  Map<String, dynamic>? getCurrentColoringSession() {
    final sessionString = prefs.getString('current_session');
    if (sessionString != null) {
      return jsonDecode(sessionString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> clearCurrentColoringSession() async {
    return await prefs.remove('current_session');
  }

  // Tutorial Progress
  Future<bool> setTutorialCompleted(String tutorialId) async {
    final completed = getCompletedTutorials();
    if (!completed.contains(tutorialId)) {
      completed.add(tutorialId);
      return await prefs.setStringList('completed_tutorials', completed);
    }
    return true;
  }

  List<String> getCompletedTutorials() {
    return prefs.getStringList('completed_tutorials') ?? [];
  }

  bool isTutorialCompleted(String tutorialId) {
    return getCompletedTutorials().contains(tutorialId);
  }

  // Clear all data
  Future<bool> clearAllData() async {
    return await prefs.clear();
  }

  // Export/Import Settings
  Map<String, dynamic> exportSettings() {
    final keys = prefs.getKeys();
    final settings = <String, dynamic>{};
    
    for (final key in keys) {
      final value = prefs.get(key);
      if (value != null) {
        settings[key] = value;
      }
    }
    
    return settings;
  }

  Future<bool> importSettings(Map<String, dynamic> settings) async {
    try {
      for (final entry in settings.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is String) {
          await prefs.setString(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}