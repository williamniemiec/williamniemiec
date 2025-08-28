import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isFirstTime = true;
  String? _userId;
  String? _userEmail;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  bool get isFirstTime => _isFirstTime;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('is_first_time') ?? true;
    _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    _userId = prefs.getString('user_id');
    _userEmail = prefs.getString('user_email');
    _userName = prefs.getString('user_name');
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isFirstTime = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _isAuthenticated = true;
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _userEmail = email;
    _userName = email.split('@')[0];
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', true);
    await prefs.setString('user_id', _userId!);
    await prefs.setString('user_email', _userEmail!);
    await prefs.setString('user_name', _userName!);
    
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _isAuthenticated = true;
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _userEmail = email;
    _userName = name;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', true);
    await prefs.setString('user_id', _userId!);
    await prefs.setString('user_email', _userEmail!);
    await prefs.setString('user_name', _userName!);
    
    notifyListeners();
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userName = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_authenticated');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    
    notifyListeners();
  }

  Future<void> skipSignIn() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}