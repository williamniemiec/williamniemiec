import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/activity.dart';
import '../models/user.dart';
import '../models/thread.dart';
import '../../core/constants/app_constants.dart';

class ActivityService {
  static const String _baseUrl = AppConstants.baseUrl;
  
  // Mock data for demo purposes
  final List<Activity> _mockActivities = [];
  final Random _random = Random();

  ActivityService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Create some mock users for activities
    final users = [
      User.create(
        username: 'alice_dev',
        displayName: 'Alice Johnson',
        bio: 'Software developer passionate about Flutter',
        profileImageUrl: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=AJ',
      ),
      User.create(
        username: 'bob_designer',
        displayName: 'Bob Smith',
        bio: 'UI/UX Designer creating beautiful experiences',
        profileImageUrl: 'https://via.placeholder.com/150/4ECDC4/FFFFFF?text=BS',
      ),
      User.create(
        username: 'carol_pm',
        displayName: 'Carol Williams',
        bio: 'Product Manager at a tech startup',
        profileImageUrl: 'https://via.placeholder.com/150/45B7D1/FFFFFF?text=CW',
      ),
      User.create(
        username: 'david_writer',
        displayName: 'David Brown',
        bio: 'Technical writer and documentation enthusiast',
        profileImageUrl: 'https://via.placeholder.com/150/96CEB4/FFFFFF?text=DB',
      ),
    ];

    // Create some mock threads for activities
    final threads = [
      Thread.create(
        content: 'Just shipped a new feature! The feeling of seeing your code in production never gets old 🚀',
        author: users[0],
      ),
      Thread.create(
        content: 'Working on a new design system. The attention to detail in spacing and typography makes all the difference.',
        author: users[1],
      ),
      Thread.create(
        content: 'Had an amazing product discovery session today. Understanding user needs is the foundation of great products.',
        author: users[2],
      ),
    ];

    // Create mock activities
    final activityTypes = ActivityType.values;
    
    for (int i = 0; i < 20; i++) {
      final actor = users[_random.nextInt(users.length)];
      final type = activityTypes[_random.nextInt(activityTypes.length)];
      final createdAt = DateTime.now().subtract(Duration(hours: i));
      
      Activity activity;
      
      if (type == ActivityType.follow) {
        // Follow activity doesn't need a thread
        activity = Activity.create(
          type: type,
          actor: actor,
        ).copyWith(createdAt: createdAt);
      } else {
        // Other activities need a thread
        final thread = threads[_random.nextInt(threads.length)];
        String? content;
        
        if (type == ActivityType.reply) {
          content = 'Great point! I totally agree with your perspective on this.';
        } else if (type == ActivityType.mention) {
          content = 'Hey @demo_user, you might find this interesting!';
        }
        
        activity = Activity.create(
          type: type,
          actor: actor,
          thread: thread,
          content: content,
        ).copyWith(
          createdAt: createdAt,
          isRead: _random.nextBool() && _random.nextInt(10) < 3, // 30% chance of being read
        );
      }
      
      _mockActivities.add(activity);
    }
    
    // Sort by creation date (newest first)
    _mockActivities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<Activity>> getActivities({int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Return paginated mock data
      final endIndex = (offset + limit).clamp(0, _mockActivities.length);
      if (offset >= _mockActivities.length) return [];
      
      return _mockActivities.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to load activities: $e');
    }
  }

  Future<List<Activity>> getUnreadActivities() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      return _mockActivities.where((activity) => !activity.isRead).toList();
    } catch (e) {
      throw Exception('Failed to load unread activities: $e');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));
      
      return _mockActivities.where((activity) => !activity.isRead).length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  Future<void> markAsRead(String activityId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _mockActivities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        _mockActivities[index] = _mockActivities[index].copyWith(isRead: true);
      }
    } catch (e) {
      throw Exception('Failed to mark activity as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      for (int i = 0; i < _mockActivities.length; i++) {
        if (!_mockActivities[i].isRead) {
          _mockActivities[i] = _mockActivities[i].copyWith(isRead: true);
        }
      }
    } catch (e) {
      throw Exception('Failed to mark all activities as read: $e');
    }
  }

  Future<Activity> createActivity({
    required ActivityType type,
    required User actor,
    User? target,
    Thread? thread,
    String? content,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      final activity = Activity.create(
        type: type,
        actor: actor,
        target: target,
        thread: thread,
        content: content,
      );
      
      // Add to mock data
      _mockActivities.insert(0, activity);
      
      return activity;
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  Future<void> deleteActivity(String activityId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      _mockActivities.removeWhere((a) => a.id == activityId);
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  Future<List<Activity>> getActivitiesByType(ActivityType type, {int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final filteredActivities = _mockActivities.where((a) => a.type == type).toList();
      
      final endIndex = (offset + limit).clamp(0, filteredActivities.length);
      if (offset >= filteredActivities.length) return [];
      
      return filteredActivities.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to get activities by type: $e');
    }
  }

  Future<List<Activity>> getActivitiesForThread(String threadId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      return _mockActivities.where((a) => a.thread?.id == threadId).toList();
    } catch (e) {
      throw Exception('Failed to get activities for thread: $e');
    }
  }

  Future<void> clearOldActivities({int daysOld = 30}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      _mockActivities.removeWhere((a) => a.createdAt.isBefore(cutoffDate));
    } catch (e) {
      throw Exception('Failed to clear old activities: $e');
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
  List<Activity> get mockActivities => List.unmodifiable(_mockActivities);
}