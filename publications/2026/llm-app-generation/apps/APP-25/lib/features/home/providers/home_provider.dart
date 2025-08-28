import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';
import '../../../core/constants/app_constants.dart';

class HomeProvider extends ChangeNotifier {
  List<RedditPost> _posts = [];
  List<Subreddit> _subscribedSubreddits = [];
  String _sortType = AppConstants.sortHot;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String? _after; // For pagination

  List<RedditPost> get posts => _posts;
  List<Subreddit> get subscribedSubreddits => _subscribedSubreddits;
  String get sortType => _sortType;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _after != null;

  HomeProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await loadSubscribedSubreddits();
    await loadPosts();
  }

  Future<void> loadSubscribedSubreddits() async {
    try {
      // For demo purposes, create mock subscribed subreddits
      _subscribedSubreddits = [
        Subreddit(
          id: 'askreddit',
          name: 't5_2qh1i',
          displayName: 'AskReddit',
          title: 'Ask Reddit...',
          description: 'r/AskReddit is the place to ask and answer thought-provoking questions.',
          subscribers: 35000000,
          createdAt: DateTime.now().subtract(const Duration(days: 5000)),
          isSubscribed: true,
        ),
        Subreddit(
          id: 'funny',
          name: 't5_2qh33',
          displayName: 'funny',
          title: 'funny',
          description: 'Welcome to r/Funny: reddit\'s largest humour depository.',
          subscribers: 40000000,
          createdAt: DateTime.now().subtract(const Duration(days: 4800)),
          isSubscribed: true,
        ),
        Subreddit(
          id: 'todayilearned',
          name: 't5_2qqjc',
          displayName: 'todayilearned',
          title: 'Today I Learned (TIL)',
          description: 'You learn something new every day; what did you learn today?',
          subscribers: 28000000,
          createdAt: DateTime.now().subtract(const Duration(days: 4500)),
          isSubscribed: true,
        ),
      ];
      notifyListeners();
    } catch (e) {
      _setError('Failed to load subscribed subreddits: ${e.toString()}');
    }
  }

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _posts.clear();
      _after = null;
    }

    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Generate mock posts
      final newPosts = _generateMockPosts();
      
      if (refresh) {
        _posts = newPosts;
      } else {
        _posts.addAll(newPosts);
      }

      _after = 'mock_after_${_posts.length}'; // Mock pagination token
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load posts: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final newPosts = _generateMockPosts(startIndex: _posts.length);
      _posts.addAll(newPosts);

      // Stop pagination after 100 posts for demo
      if (_posts.length >= 100) {
        _after = null;
      } else {
        _after = 'mock_after_${_posts.length}';
      }

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load more posts: ${e.toString()}');
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> setSortType(String sortType) async {
    if (_sortType == sortType) return;

    _sortType = sortType;
    notifyListeners();

    await loadPosts(refresh: true);
  }

  Future<void> votePost(String postId, VoteStatus voteStatus) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;

    final post = _posts[postIndex];
    final currentVote = post.userVote;
    
    // Calculate score change
    int scoreChange = 0;
    if (currentVote == VoteStatus.none) {
      scoreChange = voteStatus == VoteStatus.upvoted ? 1 : -1;
    } else if (currentVote == VoteStatus.upvoted) {
      scoreChange = voteStatus == VoteStatus.none ? -1 : -2;
    } else if (currentVote == VoteStatus.downvoted) {
      scoreChange = voteStatus == VoteStatus.none ? 1 : 2;
    }

    // Update post
    _posts[postIndex] = post.copyWith(
      userVote: voteStatus,
      score: post.score + scoreChange,
    );
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Revert on error
      _posts[postIndex] = post;
      notifyListeners();
      _setError('Failed to vote: ${e.toString()}');
    }
  }

  Future<void> savePost(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;

    final post = _posts[postIndex];
    _posts[postIndex] = post.copyWith(isSaved: !post.isSaved);
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Revert on error
      _posts[postIndex] = post;
      notifyListeners();
      _setError('Failed to save post: ${e.toString()}');
    }
  }

  List<RedditPost> _generateMockPosts({int startIndex = 0}) {
    final mockUsers = [
      RedditUser(
        id: 'user1',
        username: 'reddit_user_1',
        karma: 12345,
        commentKarma: 6789,
        linkKarma: 5556,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      RedditUser(
        id: 'user2',
        username: 'awesome_poster',
        karma: 54321,
        commentKarma: 23456,
        linkKarma: 30865,
        createdAt: DateTime.now().subtract(const Duration(days: 730)),
      ),
    ];

    return List.generate(25, (index) {
      final actualIndex = startIndex + index;
      final user = mockUsers[actualIndex % mockUsers.length];
      final subreddit = _subscribedSubreddits[actualIndex % _subscribedSubreddits.length];
      
      return RedditPost(
        id: 'post_$actualIndex',
        title: _getMockTitle(actualIndex),
        content: actualIndex % 3 == 0 ? _getMockContent(actualIndex) : null,
        type: _getMockPostType(actualIndex),
        author: user,
        subreddit: subreddit,
        createdAt: DateTime.now().subtract(Duration(hours: actualIndex + 1)),
        score: 100 + (actualIndex * 50) + (actualIndex % 10) * 100,
        commentCount: 10 + (actualIndex % 50),
        userVote: VoteStatus.none,
      );
    });
  }

  String _getMockTitle(int index) {
    final titles = [
      'What\'s the most interesting fact you know?',
      'TIL that octopuses have three hearts',
      'My cat does this weird thing every morning',
      'LPT: Always keep a backup of important files',
      'What movie completely changed your perspective on life?',
      'Scientists discover new species in deep ocean',
      'The sunset from my backyard tonight',
      'What\'s your favorite programming language and why?',
      'This restaurant has the best pizza I\'ve ever had',
      'What book should everyone read at least once?',
    ];
    return titles[index % titles.length];
  }

  String _getMockContent(int index) {
    final contents = [
      'This is a longer text post with some interesting content that users might want to read and discuss.',
      'I was thinking about this topic and wanted to share my thoughts with the community.',
      'Here\'s a detailed explanation of something I learned recently that I think others might find useful.',
    ];
    return contents[index % contents.length];
  }

  PostType _getMockPostType(int index) {
    final types = [PostType.text, PostType.image, PostType.link, PostType.text];
    return types[index % types.length];
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