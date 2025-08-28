import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _textScaleFactorKey = 'text_scale_factor';
  static const String _languageKey = 'language';

  ThemeMode _themeMode = ThemeMode.light;
  double _textScaleFactor = 1.0;
  String _language = 'en';
  bool _isLoading = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get textScaleFactor => _textScaleFactor;
  String get language => _language;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  AppProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      // Load text scale factor
      _textScaleFactor = prefs.getDouble(_textScaleFactorKey) ?? 1.0;
      
      // Load language
      _language = prefs.getString(_languageKey) ?? 'en';
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading app settings: $e');
    }
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, _themeMode.index);
      await prefs.setDouble(_textScaleFactorKey, _textScaleFactor);
      await prefs.setString(_languageKey, _language);
    } catch (e) {
      debugPrint('Error saving app settings: $e');
    }
  }

  // Toggle theme mode
  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
    await _saveSettings();
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveSettings();
    }
  }

  // Set text scale factor
  Future<void> setTextScaleFactor(double factor) async {
    if (_textScaleFactor != factor) {
      _textScaleFactor = factor.clamp(0.8, 1.5);
      notifyListeners();
      await _saveSettings();
    }
  }

  // Set language
  Future<void> setLanguage(String languageCode) async {
    if (_language != languageCode) {
      _language = languageCode;
      notifyListeners();
      await _saveSettings();
    }
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.light;
    _textScaleFactor = 1.0;
    _language = 'en';
    notifyListeners();
    await _saveSettings();
  }
}