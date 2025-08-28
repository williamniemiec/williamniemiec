import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static const String _userKey = 'current_user';
  static const String _searchHistoryKey = 'search_history';

  // Mock user data for demo
  static final User _mockUser = User(
    id: '1',
    email: 'user@gmail.com',
    name: 'John Doe',
    profileImageUrl: 'https://via.placeholder.com/150',
    preferences: const UserPreferences(
      isDarkMode: false,
      isIncognitoMode: false,
      safeSearchEnabled: true,
      voiceSearchEnabled: true,
      locationEnabled: false,
      personalizedAdsEnabled: true,
      searchHistoryEnabled: true,
      followedTopics: ['Technology', 'Science', 'News'],
      blockedSources: [],
      language: 'en',
      region: 'US',
    ),
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    lastLoginAt: DateTime.now(),
  );

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<User> signIn(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication - in real app, this would call an API
    if (email.isNotEmpty && password.isNotEmpty) {
      final user = _mockUser.copyWith(
        email: email,
        lastLoginAt: DateTime.now(),
      );
      
      await _saveUser(user);
      return user;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      await _saveUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_searchHistoryKey);
      return historyJson ?? [];
    } catch (e) {
      throw Exception('Failed to get search history: $e');
    }
  }

  Future<void> saveSearchHistory(List<String> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_searchHistoryKey, history);
    } catch (e) {
      throw Exception('Failed to save search history: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchHistoryKey);
    } catch (e) {
      throw Exception('Failed to clear search history: $e');
    }
  }

  Future<void> deleteRecentSearches() async {
    // In a real app, this would delete searches from the last 15 minutes
    // For demo purposes, we'll just clear all history
    await clearSearchHistory();
  }

  Future<void> _saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }
}