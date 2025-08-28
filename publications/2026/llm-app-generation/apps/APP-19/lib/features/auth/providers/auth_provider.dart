import 'package:flutter/foundation.dart';
import '../../../shared/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    // Simulate checking stored auth token
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, we'll simulate a logged-in user
    // In a real app, you'd check for stored tokens/credentials
    _isAuthenticated = false; // Start with login screen
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept any email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = User(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: email,
          phoneNumber: '+1 (555) 123-4567',
          dateOfBirth: DateTime(1985, 6, 15),
          biometricEnabled: true,
          notificationsEnabled: true,
        );
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Please enter valid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    // Simulate logout process
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}