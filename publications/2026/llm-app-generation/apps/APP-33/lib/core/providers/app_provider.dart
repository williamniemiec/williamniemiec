import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../shared/models/thread.dart';
import '../../shared/models/activity.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/thread_service.dart';
import '../../shared/services/user_service.dart';
import '../../shared/services/activity_service.dart';

class AppProvider with ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final ThreadService _threadService = ThreadService();
  final UserService _userService = UserService();
  final ActivityService _activityService = ActivityService();

  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Authentication state
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingThreads = false;
  bool get isLoadingThreads => _isLoadingThreads;

  // Feed data
  List<Thread> _forYouFeed = [];
  List<Thread> get forYouFeed => _forYouFeed;

  List<Thread> _followingFeed = [];
  List<Thread> get followingFeed => _followingFeed;

  // Activities
  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  int get unreadActivitiesCount => _activities.where((a) => !a.isRead).length;

  // Search results
  List<User> _searchUsers = [];
  List<User> get searchUsers => _searchUsers;

  List<Thread> _searchThreads = [];
  List<Thread> get searchThreads => _searchThreads;

  // Error handling
  String? _error;
  String? get error => _error;

  // Initialize app
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Check if user is already authenticated
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        await _loadInitialData();
      }
    } catch (e) {
      _setError('Failed to initialize app: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Authentication methods
  Future<bool> signInWithInstagram() async {
    _setLoading(true);
    _clearError();
    try {
      final user = await _authService.signInWithInstagram();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        await _loadInitialData();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to sign in: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      _clearData();
    } catch (e) {
      _setError('Failed to sign out: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Feed methods
  Future<void> loadForYouFeed({bool refresh = false}) async {
    if (refresh) {
      _forYouFeed.clear();
    }
    
    _setLoadingThreads(true);
    _clearError();
    try {
      final threads = await _threadService.getForYouFeed(
        offset: refresh ? 0 : _forYouFeed.length,
      );
      if (refresh) {
        _forYouFeed = threads;
      } else {
        _forYouFeed.addAll(threads);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load feed: $e');
    } finally {
      _setLoadingThreads(false);
    }
  }

  Future<void> loadFollowingFeed({bool refresh = false}) async {
    if (refresh) {
      _followingFeed.clear();
    }
    
    _setLoadingThreads(true);
    _clearError();
    try {
      final threads = await _threadService.getFollowingFeed(
        offset: refresh ? 0 : _followingFeed.length,
      );
      if (refresh) {
        _followingFeed = threads;
      } else {
        _followingFeed.addAll(threads);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load following feed: $e');
    } finally {
      _setLoadingThreads(false);
    }
  }

  // Thread actions
  Future<bool> createThread({
    required String content,
    List<MediaAttachment> attachments = const [],
    String? parentThreadId,
    String? quotedThreadId,
  }) async {
    if (_currentUser == null) return false;

    _clearError();
    try {
      final thread = await _threadService.createThread(
        content: content,
        author: _currentUser!,
        attachments: attachments,
        parentThreadId: parentThreadId,
        quotedThreadId: quotedThreadId,
      );

      // Add to appropriate feeds
      if (parentThreadId == null) {
        _forYouFeed.insert(0, thread);
        _followingFeed.insert(0, thread);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create thread: $e');
      return false;
    }
  }

  Future<void> toggleLike(String threadId) async {
    if (_currentUser == null) return;

    _clearError();
    try {
      final isLiked = await _threadService.toggleLike(threadId);
      
      // Update thread in feeds
      _updateThreadInFeeds(threadId, (thread) {
        return thread.copyWith(
          isLiked: isLiked,
          likesCount: isLiked ? thread.likesCount + 1 : thread.likesCount - 1,
        );
      });
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle like: $e');
    }
  }

  Future<void> toggleRepost(String threadId) async {
    if (_currentUser == null) return;

    _clearError();
    try {
      final isReposted = await _threadService.toggleRepost(threadId);
      
      // Update thread in feeds
      _updateThreadInFeeds(threadId, (thread) {
        return thread.copyWith(
          isReposted: isReposted,
          repostsCount: isReposted ? thread.repostsCount + 1 : thread.repostsCount - 1,
        );
      });
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle repost: $e');
    }
  }

  // Search methods
  Future<void> performUserSearch(String query) async {
    if (query.isEmpty) {
      _searchUsers.clear();
      notifyListeners();
      return;
    }

    _clearError();
    try {
      _searchUsers = await _userService.searchUsers(query);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search users: $e');
    }
  }

  Future<void> performThreadSearch(String query) async {
    if (query.isEmpty) {
      _searchThreads.clear();
      notifyListeners();
      return;
    }

    _clearError();
    try {
      _searchThreads = await _threadService.searchThreads(query);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search threads: $e');
    }
  }

  // Activity methods
  Future<void> loadActivities({bool refresh = false}) async {
    if (refresh) {
      _activities.clear();
    }

    _clearError();
    try {
      final activities = await _activityService.getActivities(
        offset: refresh ? 0 : _activities.length,
      );
      if (refresh) {
        _activities = activities;
      } else {
        _activities.addAll(activities);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to load activities: $e');
    }
  }

  Future<void> markActivityAsRead(String activityId) async {
    try {
      await _activityService.markAsRead(activityId);
      final index = _activities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        _activities[index] = _activities[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to mark activity as read: $e');
    }
  }

  // User actions
  Future<void> followUser(String userId) async {
    if (_currentUser == null) return;

    _clearError();
    try {
      await _userService.followUser(userId);
      // Update user in search results if present
      final index = _searchUsers.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _searchUsers[index] = _searchUsers[index].copyWith(
          followersCount: _searchUsers[index].followersCount + 1,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to follow user: $e');
    }
  }

  Future<void> unfollowUser(String userId) async {
    if (_currentUser == null) return;

    _clearError();
    try {
      await _userService.unfollowUser(userId);
      // Update user in search results if present
      final index = _searchUsers.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _searchUsers[index] = _searchUsers[index].copyWith(
          followersCount: _searchUsers[index].followersCount - 1,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to unfollow user: $e');
    }
  }

  // Private helper methods
  Future<void> _loadInitialData() async {
    await Future.wait([
      loadForYouFeed(refresh: true),
      loadActivities(refresh: true),
    ]);
  }

  void _updateThreadInFeeds(String threadId, Thread Function(Thread) updater) {
    // Update in for you feed
    final forYouIndex = _forYouFeed.indexWhere((t) => t.id == threadId);
    if (forYouIndex != -1) {
      _forYouFeed[forYouIndex] = updater(_forYouFeed[forYouIndex]);
    }

    // Update in following feed
    final followingIndex = _followingFeed.indexWhere((t) => t.id == threadId);
    if (followingIndex != -1) {
      _followingFeed[followingIndex] = updater(_followingFeed[followingIndex]);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingThreads(bool loading) {
    _isLoadingThreads = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _clearData() {
    _forYouFeed.clear();
    _followingFeed.clear();
    _activities.clear();
    _searchUsers.clear();
    _searchThreads.clear();
    notifyListeners();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}