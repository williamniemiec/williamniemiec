import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../../core/constants/app_constants.dart';

class AuthService {
  static const String _baseUrl = AppConstants.baseUrl;
  
  // Mock authentication for demo purposes
  User? _currentUser;

  Future<User?> getCurrentUser() async {
    // In a real app, this would check stored tokens and validate with server
    return _currentUser;
  }

  Future<User?> signInWithInstagram() async {
    try {
      // Mock Instagram authentication
      // In a real app, this would integrate with Instagram's OAuth flow
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // Create a mock user for demo
      final user = User.create(
        username: 'demo_user',
        displayName: 'Demo User',
        bio: 'Welcome to Threads! This is a demo account.',
        profileImageUrl: 'https://via.placeholder.com/150',
        instagramUsername: 'demo_user_ig',
      );
      
      _currentUser = user;
      return user;
    } catch (e) {
      throw Exception('Failed to sign in with Instagram: $e');
    }
  }

  Future<void> signOut() async {
    try {
      // In a real app, this would invalidate tokens on the server
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<User> registerUser({
    required String username,
    required String displayName,
    String? bio,
    String? profileImageUrl,
    String? instagramUsername,
  }) async {
    try {
      // Mock user registration
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User.create(
        username: username,
        displayName: displayName,
        bio: bio,
        profileImageUrl: profileImageUrl,
        instagramUsername: instagramUsername,
      );
      
      _currentUser = user;
      return user;
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      // Mock username availability check
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For demo, consider some usernames as taken
      final takenUsernames = ['admin', 'threads', 'instagram', 'meta'];
      return !takenUsernames.contains(username.toLowerCase());
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = _currentUser!.copyWith(
        displayName: displayName ?? _currentUser!.displayName,
        bio: bio ?? _currentUser!.bio,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> deleteAccount() async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // Mock account deletion
      await Future.delayed(const Duration(seconds: 2));
      _currentUser = null;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Helper method to make authenticated requests
  Future<http.Response> _makeAuthenticatedRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getAuthToken()}',
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  String? _getAuthToken() {
    // In a real app, this would return the stored auth token
    return _currentUser != null ? 'mock_token_${_currentUser!.id}' : null;
  }

  bool get isAuthenticated => _currentUser != null;
}