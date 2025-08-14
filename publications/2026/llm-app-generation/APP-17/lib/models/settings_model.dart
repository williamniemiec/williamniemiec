import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  bool _javaScriptEnabled = true;
  bool _torEnabled = false;

  bool get javaScriptEnabled => _javaScriptEnabled;
  bool get torEnabled => _torEnabled;

  SettingsModel() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _javaScriptEnabled = prefs.getBool('javaScriptEnabled') ?? true;
    _torEnabled = prefs.getBool('torEnabled') ?? false;
    notifyListeners();
  }

  Future<void> setJavaScriptEnabled(bool value) async {
    _javaScriptEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('javaScriptEnabled', value);
    notifyListeners();
  }

  Future<void> setTorEnabled(bool value) async {
    _torEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('torEnabled', value);
    notifyListeners();
  }
}