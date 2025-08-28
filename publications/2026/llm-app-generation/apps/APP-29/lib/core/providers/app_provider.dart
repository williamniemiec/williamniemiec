import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = false;

  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadThemeMode();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString());
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode');
    
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'ThemeMode.light':
          _themeMode = ThemeMode.light;
          break;
        case 'ThemeMode.dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'ThemeMode.system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}