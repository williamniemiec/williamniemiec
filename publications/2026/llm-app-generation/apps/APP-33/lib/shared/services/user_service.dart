import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../../core/constants/app_constants.dart';

class UserService {
  static const String _baseUrl = AppConstants.baseUrl;
  
  // Mock data for demo purposes
  final List<User> _mockUsers = [];
  final Set<String> _followingIds = {};
  final Random _random = Random();

  UserService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Create mock users for search and discovery
    final mockUserData = [
      {
        'username': 'sarah_tech',
        'displayName': 'Sarah Johnson',
        'bio': 'Senior Software Engineer at Google. Flutter enthusiast.',
        'color': 'FF6B6B',
      },
      {
        'username': 'mike_design',
        'displayName': 'Mike Chen',
        'bio': 'Product Designer crafting delightful user experiences.',
        'color': '4ECDC4',
      },
      {
        'username': 'lisa_startup',
        'displayName': 'Lisa Rodriguez',
        'bio': 'Startup founder building the future of fintech.',
        'color': '45B7D1',
      },
      {
        'username': 'alex_writer',
        'displayName': 'Alex Thompson',
        'bio': 'Technical writer and developer advocate.',
        'color': '96CEB4',
      },
      {
        'username': 'jenny_ai',
        'displayName': 'Jenny Park',
        'bio': 'AI researcher exploring the frontiers of machine learning.',
        'color': 'FFEAA7',
      },
      {
        'username': 'tom_mobile',
        'displayName': 'Tom Wilson',
        'bio': 'Mobile app developer. iOS and Android expert.',
        'color': 'DDA0DD',
      },
      {
        'username': 'anna_ux',
        'displayName': 'Anna Martinez',
        'bio': 'UX researcher passionate about human-centered design.',
        'color': 'F7DC6F',
      },
      {
        'username': 'chris_backend',
        'displayName': 'Chris Anderson',
        'bio': 'Backend engineer scaling systems for millions of users.',
        'color': '85C1E9',
      },
      {
        'username': 'maya_product',
        'displayName': 'Maya Patel',
        'bio': 'Product manager turning ideas into reality.',
        'color': 'F8C471',
      },
      {
        'username': 'ryan_security',
        'displayName': 'Ryan Davis',
        'bio': 'Cybersecurity expert protecting digital assets.',
        'color': 'BB8FCE',
      },
    ];

    for (final userData in mockUserData) {
      final user = User.create(
        username: userData['username'] as String,
        displayName: userData['displayName'] as String,
        bio: userData['bio'] as String,
        profileImageUrl: 'https://via.placeholder.com/150/${userData['color']}/FFFFFF?text=${(userData['displayName'] as String).split(' ').map((n) => n[0]).join('')}',
        instagramUsername: '${userData['username']}_ig',
      ).copyWith(
        followersCount: _random.nextInt(10000) + 100,
        followingCount: _random.nextInt(1000) + 50,
        threadsCount: _random.nextInt(500) + 10,
        isVerified: _random.nextBool() && _random.nextInt(10) < 3, // 30% chance of being verified
      );
      
      _mockUsers.add(user);
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      if (query.isEmpty) return [];
      
      // Simple text search in mock data
      final results = _mockUsers.where((user) =>
        user.displayName.toLowerCase().contains(query.toLowerCase()) ||
        user.username.toLowerCase().contains(query.toLowerCase()) ||
        (user.bio?.toLowerCase().contains(query.toLowerCase()) ?? false)
      ).toList();
      
      return results;
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      return _mockUsers.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      return _mockUsers.firstWhere(
        (u) => u.username.toLowerCase() == username.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      throw Exception('Failed to get user by username: $e');
    }
  }

  Future<List<User>> getFollowers(String userId, {int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For demo, return a subset of mock users as followers
      final followers = _mockUsers.take(10).toList();
      
      final endIndex = (offset + limit).clamp(0, followers.length);
      if (offset >= followers.length) return [];
      
      return followers.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to get followers: $e');
    }
  }

  Future<List<User>> getFollowing(String userId, {int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For demo, return users that are being followed
      final following = _mockUsers.where((u) => _followingIds.contains(u.id)).toList();
      
      final endIndex = (offset + limit).clamp(0, following.length);
      if (offset >= following.length) return [];
      
      return following.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to get following: $e');
    }
  }

  Future<void> followUser(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      _followingIds.add(userId);
      
      // Update follower count in mock data
      final userIndex = _mockUsers.indexWhere((u) => u.id == userId);
      if (userIndex != -1) {
        _mockUsers[userIndex] = _mockUsers[userIndex].copyWith(
          followersCount: _mockUsers[userIndex].followersCount + 1,
        );
      }
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  Future<void> unfollowUser(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      _followingIds.remove(userId);
      
      // Update follower count in mock data
      final userIndex = _mockUsers.indexWhere((u) => u.id == userId);
      if (userIndex != -1) {
        _mockUsers[userIndex] = _mockUsers[userIndex].copyWith(
          followersCount: (_mockUsers[userIndex].followersCount - 1).clamp(0, double.infinity).toInt(),
        );
      }
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }

  Future<bool> isFollowing(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));
      
      return _followingIds.contains(userId);
    } catch (e) {
      throw Exception('Failed to check following status: $e');
    }
  }

  Future<List<User>> getSuggestedUsers({int limit = 10}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 700));
      
      // Return users not being followed as suggestions
      final suggestions = _mockUsers.where((u) => !_followingIds.contains(u.id)).take(limit).toList();
      
      // Shuffle for variety
      suggestions.shuffle(_random);
      
      return suggestions;
    } catch (e) {
      throw Exception('Failed to get suggested users: $e');
    }
  }

  Future<User> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      final userIndex = _mockUsers.indexWhere((u) => u.id == userId);
      if (userIndex == -1) throw Exception('User not found');
      
      _mockUsers[userIndex] = _mockUsers[userIndex].copyWith(
        displayName: displayName ?? _mockUsers[userIndex].displayName,
        bio: bio ?? _mockUsers[userIndex].bio,
        profileImageUrl: profileImageUrl ?? _mockUsers[userIndex].profileImageUrl,
      );
      
      return _mockUsers[userIndex];
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In a real app, this would add the user to a blocked list
      // For demo, we'll just unfollow them
      _followingIds.remove(userId);
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In a real app, this would remove the user from the blocked list
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  Future<void> reportUser(String userId, String reason) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // In a real app, this would send a report to the moderation system
    } catch (e) {
      throw Exception('Failed to report user: $e');
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
    return 'mock_token';
  }

  // Getters for mock data (useful for testing)
  List<User> get mockUsers => List.unmodifiable(_mockUsers);
  Set<String> get followingIds => Set.unmodifiable(_followingIds);
}