import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/models.dart';
import '../../../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  RedditUser? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  RedditUser? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.userDataKey);
      final token = prefs.getString(AppConstants.userTokenKey);
      
      if (userData != null && token != null) {
        // In a real app, you would parse the JSON and validate the token
        _isAuthenticated = true;
        // For demo purposes, create a mock user
        _currentUser = RedditUser(
          id: 'demo_user',
          username: 'demo_user',
          displayName: 'Demo User',
          karma: 1234,
          commentKarma: 567,
          linkKarma: 667,
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
        );
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to load user data';
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept any non-empty credentials
      if (username.isNotEmpty && password.isNotEmpty) {
        _currentUser = RedditUser(
          id: 'user_${username.toLowerCase()}',
          username: username,
          displayName: username,
          karma: 1234,
          commentKarma: 567,
          linkKarma: 667,
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
        );
        
        _isAuthenticated = true;
        
        // Save to storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userTokenKey, 'demo_token');
        await prefs.setString(AppConstants.userDataKey, 'demo_user_data');
        
        _setLoading(false);
        return true;
      } else {
        _setError('Please enter valid credentials');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept any non-empty credentials
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _currentUser = RedditUser(
          id: 'user_${username.toLowerCase()}',
          username: username,
          displayName: username,
          karma: 0,
          commentKarma: 0,
          linkKarma: 0,
          createdAt: DateTime.now(),
        );
        
        _isAuthenticated = true;
        
        // Save to storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userTokenKey, 'demo_token');
        await prefs.setString(AppConstants.userDataKey, 'demo_user_data');
        
        _setLoading(false);
        return true;
      } else {
        _setError('Please fill in all fields');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userTokenKey);
      await prefs.remove(AppConstants.userDataKey);
      
      _currentUser = null;
      _isAuthenticated = false;
      _clearError();
      
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? description,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = _currentUser!.copyWith(
        displayName: displayName,
        description: description,
        avatarUrl: avatarUrl,
      );
      
      _setLoading(false);
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}