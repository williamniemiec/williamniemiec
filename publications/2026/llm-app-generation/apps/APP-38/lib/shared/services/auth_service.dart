import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../../core/constants/app_constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  String? _authToken;

  User? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  // Initialize auth service and check for stored credentials
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load stored token
    _authToken = prefs.getString(AppConstants.userTokenKey);
    
    // Load stored user data
    final userDataJson = prefs.getString(AppConstants.userDataKey);
    if (userDataJson != null) {
      try {
        final userData = jsonDecode(userDataJson);
        _currentUser = User.fromJson(userData);
      } catch (e) {
        // Clear invalid stored data
        await clearStoredCredentials();
      }
    }
  }

  // Sign in with email and password
  Future<AuthResult> signIn(String email, String password) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock authentication - in real app, this would call your API
      if (email.isNotEmpty && password.length >= 6) {
        final user = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          firstName: 'John',
          lastName: 'Doe',
          createdAt: DateTime.now(),
          isGeniusMember: email.contains('genius'),
          geniusLevel: email.contains('genius') ? 1 : 0,
        );
        
        final token = 'mock_token_${user.id}';
        
        await _storeCredentials(user, token);
        _currentUser = user;
        _authToken = token;
        
        return AuthResult.success(user);
      } else {
        return AuthResult.failure('Invalid email or password');
      }
    } catch (e) {
      return AuthResult.failure('Authentication failed: ${e.toString()}');
    }
  }

  // Sign up with user details
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock registration - in real app, this would call your API
      if (email.isNotEmpty && password.length >= 6 && firstName.isNotEmpty && lastName.isNotEmpty) {
        final user = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
        );
        
        final token = 'mock_token_${user.id}';
        
        await _storeCredentials(user, token);
        _currentUser = user;
        _authToken = token;
        
        return AuthResult.success(user);
      } else {
        return AuthResult.failure('Please fill in all required fields');
      }
    } catch (e) {
      return AuthResult.failure('Registration failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await clearStoredCredentials();
    _currentUser = null;
    _authToken = null;
  }

  // Update user profile
  Future<AuthResult> updateProfile(User updatedUser) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock update - in real app, this would call your API
      _currentUser = updatedUser;
      await _storeUser(updatedUser);
      
      return AuthResult.success(updatedUser);
    } catch (e) {
      return AuthResult.failure('Profile update failed: ${e.toString()}');
    }
  }

  // Change password
  Future<AuthResult> changePassword(String currentPassword, String newPassword) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock password change - in real app, this would call your API
      if (currentPassword.length >= 6 && newPassword.length >= 6) {
        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.failure('Password must be at least 6 characters');
      }
    } catch (e) {
      return AuthResult.failure('Password change failed: ${e.toString()}');
    }
  }

  // Reset password
  Future<AuthResult> resetPassword(String email) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock password reset - in real app, this would call your API
      if (email.isNotEmpty && email.contains('@')) {
        return AuthResult.success(null, message: 'Password reset email sent');
      } else {
        return AuthResult.failure('Please enter a valid email address');
      }
    } catch (e) {
      return AuthResult.failure('Password reset failed: ${e.toString()}');
    }
  }

  // Store credentials locally
  Future<void> _storeCredentials(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userTokenKey, token);
    await prefs.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
  }

  // Store user data locally
  Future<void> _storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
  }

  // Clear stored credentials
  Future<void> clearStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userDataKey);
  }

  // Validate token (check if still valid)
  Future<bool> validateToken() async {
    if (_authToken == null) return false;
    
    try {
      // Simulate API call to validate token
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock validation - in real app, this would call your API
      return _authToken!.startsWith('mock_token_');
    } catch (e) {
      return false;
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? message;
  final String? error;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.message,
    this.error,
  });

  factory AuthResult.success(User? user, {String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'AuthResult.success(user: ${user?.email}, message: $message)';
    } else {
      return 'AuthResult.failure(error: $error)';
    }
  }
}