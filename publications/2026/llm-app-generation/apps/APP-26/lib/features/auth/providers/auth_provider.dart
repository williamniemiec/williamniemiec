import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/user.dart';
import '../../../shared/services/api_service.dart';
import '../../../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  final ApiService _apiService = ApiService();

  AuthProvider() {
    _loadUserFromStorage();
  }

  // Load user from local storage on app start
  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConstants.userCacheKey);
      
      if (userJson != null) {
        // In a real app, you'd parse the JSON and create a User object
        // For now, we'll create a mock user
        _isAuthenticated = true;
        _currentUser = _createMockUser();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from storage: $e');
    }
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // In a real app, you'd make an API call here
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock successful login
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = _createMockUser();
        _isAuthenticated = true;
        
        // Save user to local storage
        await _saveUserToStorage();
        
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // In a real app, you'd make an API call here
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock successful registration
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        _currentUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          username: username,
          displayName: displayName,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isAuthenticated = true;
        
        // Save user to local storage
        await _saveUserToStorage();
        
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        throw Exception('All fields are required');
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userCacheKey);
      
      // Clear state
      _currentUser = null;
      _isAuthenticated = false;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? bio,
    String? location,
    String? website,
    String? profileImageUrl,
    String? bannerImageUrl,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // In a real app, you'd make an API call here
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _currentUser = _currentUser!.copyWith(
        displayName: displayName ?? _currentUser!.displayName,
        bio: bio ?? _currentUser!.bio,
        location: location ?? _currentUser!.location,
        website: website ?? _currentUser!.website,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        bannerImageUrl: bannerImageUrl ?? _currentUser!.bannerImageUrl,
        updatedAt: DateTime.now(),
      );
      
      // Save updated user to local storage
      await _saveUserToStorage();
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Follow/Unfollow user
  Future<bool> toggleFollow(String userId) async {
    if (_currentUser == null) return false;

    try {
      // In a real app, you'd make an API call here
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock success
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Helper methods
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
  }

  Future<void> _saveUserToStorage() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userCacheKey, _currentUser!.toJson().toString());
    }
  }

  User _createMockUser() {
    return User(
      id: '1',
      username: 'john_doe',
      displayName: 'John Doe',
      email: 'john@example.com',
      bio: 'Flutter developer and X enthusiast',
      location: 'San Francisco, CA',
      website: 'https://johndoe.dev',
      profileImageUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
      followersCount: 1234,
      followingCount: 567,
      postsCount: 89,
      isVerified: true,
      isPremium: true,
    );
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Mock check - in real app, make API call
      return username.length >= 3 && !username.contains(' ');
    } catch (e) {
      return false;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      // Mock success
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}