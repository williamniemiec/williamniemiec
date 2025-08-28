import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/api_service.dart';
import '../../../core/constants/app_constants.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // State variables
  List<Post> _forYouPosts = [];
  List<Post> _followingPosts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePosts = true;
  int _selectedTabIndex = 0; // 0 = For You, 1 = Following

  // Getters
  List<Post> get forYouPosts => _forYouPosts;
  List<Post> get followingPosts => _followingPosts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMorePosts => _hasMorePosts;
  int get selectedTabIndex => _selectedTabIndex;
  
  List<Post> get currentPosts => _selectedTabIndex == 0 ? _forYouPosts : _followingPosts;

  HomeProvider() {
    loadInitialPosts();
  }

  // Load initial posts
  Future<void> loadInitialPosts() async {
    _setLoading(true);
    _clearError();
    _currentPage = 1;
    _hasMorePosts = true;

    try {
      // Load both For You and Following posts
      await Future.wait([
        _loadForYouPosts(refresh: true),
        _loadFollowingPosts(refresh: true),
      ]);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load For You posts
  Future<void> _loadForYouPosts({bool refresh = false}) async {
    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));
      
      final mockPosts = _generateMockPosts(refresh ? 0 : _forYouPosts.length);
      
      if (refresh) {
        _forYouPosts = mockPosts;
      } else {
        _forYouPosts.addAll(mockPosts);
      }
    } catch (e) {
      throw Exception('Failed to load For You posts: $e');
    }
  }

  // Load Following posts
  Future<void> _loadFollowingPosts({bool refresh = false}) async {
    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));
      
      final mockPosts = _generateMockPosts(refresh ? 0 : _followingPosts.length, isFollowing: true);
      
      if (refresh) {
        _followingPosts = mockPosts;
      } else {
        _followingPosts.addAll(mockPosts);
      }
    } catch (e) {
      throw Exception('Failed to load Following posts: $e');
    }
  }

  // Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMorePosts) return;

    _setLoadingMore(true);
    _currentPage++;

    try {
      if (_selectedTabIndex == 0) {
        await _loadForYouPosts();
      } else {
        await _loadFollowingPosts();
      }
      
      // Simulate end of posts after page 5
      if (_currentPage >= 5) {
        _hasMorePosts = false;
      }
    } catch (e) {
      _setError(e.toString());
      _currentPage--; // Revert page increment on error
    } finally {
      _setLoadingMore(false);
    }
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    await loadInitialPosts();
  }

  // Switch between For You and Following tabs
  void switchTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  // Like/Unlike post
  Future<void> toggleLike(String postId) async {
    try {
      final postIndex = currentPosts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final post = currentPosts[postIndex];
      final newPost = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );

      // Update the appropriate list
      if (_selectedTabIndex == 0) {
        _forYouPosts[postIndex] = newPost;
      } else {
        _followingPosts[postIndex] = newPost;
      }

      notifyListeners();

      // In a real app, make API call here
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      _setError('Failed to like post: $e');
    }
  }

  // Repost
  Future<void> toggleRepost(String postId) async {
    try {
      final postIndex = currentPosts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final post = currentPosts[postIndex];
      final newPost = post.copyWith(
        isReposted: !post.isReposted,
        repostsCount: post.isReposted ? post.repostsCount - 1 : post.repostsCount + 1,
      );

      // Update the appropriate list
      if (_selectedTabIndex == 0) {
        _forYouPosts[postIndex] = newPost;
      } else {
        _followingPosts[postIndex] = newPost;
      }

      notifyListeners();

      // In a real app, make API call here
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      _setError('Failed to repost: $e');
    }
  }

  // Bookmark post
  Future<void> toggleBookmark(String postId) async {
    try {
      final postIndex = currentPosts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final post = currentPosts[postIndex];
      final newPost = post.copyWith(
        isBookmarked: !post.isBookmarked,
        bookmarksCount: post.isBookmarked ? post.bookmarksCount - 1 : post.bookmarksCount + 1,
      );

      // Update the appropriate list
      if (_selectedTabIndex == 0) {
        _forYouPosts[postIndex] = newPost;
      } else {
        _followingPosts[postIndex] = newPost;
      }

      notifyListeners();

      // In a real app, make API call here
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      _setError('Failed to bookmark post: $e');
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Generate mock posts for development
  List<Post> _generateMockPosts(int startIndex, {bool isFollowing = false}) {
    final posts = <Post>[];
    final now = DateTime.now();

    for (int i = 0; i < AppConstants.postsPerPage; i++) {
      final index = startIndex + i;
      final user = _generateMockUser(index);
      
      posts.add(Post(
        id: 'post_$index',
        authorId: user.id,
        author: user,
        content: _generateMockContent(index),
        type: AppConstants.textPost,
        createdAt: now.subtract(Duration(hours: index)),
        updatedAt: now.subtract(Duration(hours: index)),
        likesCount: (index * 12) % 1000,
        repostsCount: (index * 5) % 100,
        repliesCount: (index * 3) % 50,
        viewsCount: (index * 100) % 10000,
        bookmarksCount: (index * 2) % 25,
        isLiked: index % 4 == 0,
        isReposted: index % 7 == 0,
        isBookmarked: index % 9 == 0,
        hashtags: _generateHashtags(index),
        mentions: _generateMentions(index),
      ));
    }

    return posts;
  }

  User _generateMockUser(int index) {
    final usernames = ['john_doe', 'jane_smith', 'tech_guru', 'design_pro', 'flutter_dev'];
    final displayNames = ['John Doe', 'Jane Smith', 'Tech Guru', 'Design Pro', 'Flutter Dev'];
    
    final userIndex = index % usernames.length;
    
    return User(
      id: 'user_$userIndex',
      username: usernames[userIndex],
      displayName: displayNames[userIndex],
      email: '${usernames[userIndex]}@example.com',
      bio: 'Mock user bio for ${displayNames[userIndex]}',
      createdAt: DateTime.now().subtract(Duration(days: 365)),
      updatedAt: DateTime.now(),
      followersCount: (userIndex * 1000) + 500,
      followingCount: (userIndex * 100) + 50,
      postsCount: (userIndex * 50) + 25,
      isVerified: userIndex % 3 == 0,
      isPremium: userIndex % 4 == 0,
    );
  }

  String _generateMockContent(int index) {
    final contents = [
      'Just shipped a new feature! 🚀 Excited to see how users respond to the latest updates.',
      'Beautiful sunset today 🌅 Sometimes you need to step away from the screen and enjoy nature.',
      'Working on some exciting Flutter animations. The possibilities are endless! #Flutter #Mobile',
      'Coffee ☕ + Code 💻 = Perfect morning. What\'s your favorite coding setup?',
      'Thoughts on the latest tech trends? AI is changing everything we know about development.',
      'Weekend project: Building a weather app with beautiful UI. Design matters! #UX #Design',
      'Just finished reading an amazing book on software architecture. Highly recommend! 📚',
      'The community here is incredible. Thanks for all the support and feedback! 🙏',
      'Debugging is like being a detective in a crime movie where you are also the murderer 🕵️‍♂️',
      'Remember: Code is read more often than it is written. Keep it clean and simple! ✨',
    ];
    
    return contents[index % contents.length];
  }

  List<String> _generateHashtags(int index) {
    final allHashtags = ['Flutter', 'Dart', 'Mobile', 'iOS', 'Android', 'UI', 'UX', 'Design', 'Code', 'Tech'];
    final count = (index % 3) + 1;
    return allHashtags.take(count).toList();
  }

  List<String> _generateMentions(int index) {
    if (index % 5 == 0) {
      return ['@flutter', '@google'];
    }
    return [];
  }
}