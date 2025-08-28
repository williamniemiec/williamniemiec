import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class DiscoverProvider extends ChangeNotifier {
  List<Subreddit> _popularSubreddits = [];
  List<RedditPost> _trendingPosts = [];
  List<Subreddit> _searchResults = [];
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;

  List<Subreddit> get popularSubreddits => _popularSubreddits;
  List<RedditPost> get trendingPosts => _trendingPosts;
  List<Subreddit> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;

  DiscoverProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await loadPopularSubreddits();
    await loadTrendingPosts();
  }

  Future<void> loadPopularSubreddits() async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      _popularSubreddits = _generateMockSubreddits();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load popular subreddits: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<void> loadTrendingPosts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _trendingPosts = _generateMockTrendingPosts();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load trending posts: ${e.toString()}');
    }
  }

  Future<void> searchSubreddits(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _searchQuery = query;
    _isSearching = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _searchResults = _popularSubreddits
          .where((subreddit) =>
              subreddit.displayName.toLowerCase().contains(query.toLowerCase()) ||
              subreddit.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      _setError('Search failed: ${e.toString()}');
      _isSearching = false;
      notifyListeners();
    }
  }

  List<Subreddit> _generateMockSubreddits() {
    return [
      Subreddit(
        id: 'programming',
        name: 't5_2fwo',
        displayName: 'programming',
        title: 'Computer Programming',
        description: 'Computer Programming',
        subscribers: 4500000,
        createdAt: DateTime.now().subtract(const Duration(days: 4000)),
      ),
      Subreddit(
        id: 'science',
        name: 't5_mouw',
        displayName: 'science',
        title: 'Science',
        description: 'This community is a place to share and discuss new scientific research.',
        subscribers: 28000000,
        createdAt: DateTime.now().subtract(const Duration(days: 5000)),
      ),
      Subreddit(
        id: 'technology',
        name: 't5_2qh16',
        displayName: 'technology',
        title: 'Technology',
        description: 'Subreddit dedicated to the news and discussions about the creation and use of technology.',
        subscribers: 12000000,
        createdAt: DateTime.now().subtract(const Duration(days: 4500)),
      ),
    ];
  }

  List<RedditPost> _generateMockTrendingPosts() {
    final mockUser = RedditUser(
      id: 'trending_user',
      username: 'trending_poster',
      karma: 50000,
      commentKarma: 25000,
      linkKarma: 25000,
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
    );

    return [
      RedditPost(
        id: 'trending_1',
        title: 'Breaking: Major scientific discovery announced',
        type: PostType.link,
        author: mockUser,
        subreddit: _popularSubreddits[1], // science
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        score: 15000,
        commentCount: 1200,
      ),
      RedditPost(
        id: 'trending_2',
        title: 'New programming language gains popularity',
        type: PostType.text,
        author: mockUser,
        subreddit: _popularSubreddits[0], // programming
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        score: 8500,
        commentCount: 650,
      ),
    ];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}