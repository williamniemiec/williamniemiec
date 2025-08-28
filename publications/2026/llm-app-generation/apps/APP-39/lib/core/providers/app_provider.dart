import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../shared/models/discover_article.dart';
import '../../shared/models/search_result.dart';
import '../../shared/services/user_service.dart';
import '../../shared/services/search_service.dart';
import '../../shared/services/discover_service.dart';

class AppProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final SearchService _searchService = SearchService();
  final DiscoverService _discoverService = DiscoverService();

  // User state
  User? _currentUser;
  bool _isAuthenticated = false;

  // Search state
  List<SearchResult> _searchResults = [];
  List<String> _searchHistory = [];
  List<String> _searchSuggestions = [];
  bool _isSearching = false;
  String _currentQuery = '';

  // Discover state
  List<DiscoverArticle> _discoverArticles = [];
  bool _isLoadingDiscover = false;
  bool _hasMoreDiscover = true;

  // App state
  bool _isLoading = false;
  String? _errorMessage;
  ThemeMode _themeMode = ThemeMode.system;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  List<SearchResult> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  List<String> get searchSuggestions => _searchSuggestions;
  bool get isSearching => _isSearching;
  String get currentQuery => _currentQuery;
  List<DiscoverArticle> get discoverArticles => _discoverArticles;
  bool get isLoadingDiscover => _isLoadingDiscover;
  bool get hasMoreDiscover => _hasMoreDiscover;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  bool get isIncognitoMode => _currentUser?.preferences.isIncognitoMode ?? false;

  // Initialize app
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _loadUserPreferences();
      await _loadSearchHistory();
      await _loadDiscoverFeed();
    } catch (e) {
      _setError('Failed to initialize app: $e');
    } finally {
      _setLoading(false);
    }
  }

  // User methods
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _userService.signIn(email, password);
      _currentUser = user;
      _isAuthenticated = true;
      _updateThemeMode(user.preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);
      await _loadSearchHistory();
      await _loadDiscoverFeed();
      _clearError();
    } catch (e) {
      _setError('Sign in failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _userService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      _searchHistory.clear();
      _discoverArticles.clear();
      _clearError();
    } catch (e) {
      _setError('Sign out failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserPreferences(UserPreferences preferences) async {
    if (_currentUser == null) return;

    try {
      final updatedUser = _currentUser!.copyWith(preferences: preferences);
      await _userService.updateUser(updatedUser);
      _currentUser = updatedUser;
      _updateThemeMode(preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update preferences: $e');
    }
  }

  // Search methods
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    _currentQuery = query;
    _isSearching = true;
    notifyListeners();

    try {
      final results = await _searchService.search(query);
      _searchResults = results;
      
      if (!isIncognitoMode) {
        await _addToSearchHistory(query);
      }
      
      _clearError();
    } catch (e) {
      _setError('Search failed: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> getSearchSuggestions(String query) async {
    if (query.trim().isEmpty) {
      _searchSuggestions.clear();
      notifyListeners();
      return;
    }

    try {
      final suggestions = await _searchService.getSuggestions(query);
      _searchSuggestions = suggestions;
      notifyListeners();
    } catch (e) {
      // Silently fail for suggestions
      _searchSuggestions.clear();
      notifyListeners();
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      await _userService.clearSearchHistory();
      _searchHistory.clear();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear search history: $e');
    }
  }

  Future<void> deleteRecentSearches() async {
    try {
      await _userService.deleteRecentSearches();
      // Remove searches from last 15 minutes
      final cutoff = DateTime.now().subtract(const Duration(minutes: 15));
      _searchHistory.removeWhere((query) {
        // This is simplified - in real app, you'd store timestamps
        return true; // Remove all for demo
      });
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete recent searches: $e');
    }
  }

  // Discover methods
  Future<void> loadDiscoverFeed({bool refresh = false}) async {
    if (refresh) {
      _discoverArticles.clear();
      _hasMoreDiscover = true;
    }

    if (!_hasMoreDiscover) return;

    _isLoadingDiscover = true;
    notifyListeners();

    try {
      final articles = await _discoverService.getDiscoverFeed(
        offset: refresh ? 0 : _discoverArticles.length,
        interests: _currentUser?.preferences.followedTopics ?? [],
      );
      
      if (refresh) {
        _discoverArticles = articles;
      } else {
        _discoverArticles.addAll(articles);
      }
      
      _hasMoreDiscover = articles.length >= 20; // Page size
      _clearError();
    } catch (e) {
      _setError('Failed to load discover feed: $e');
    } finally {
      _isLoadingDiscover = false;
      notifyListeners();
    }
  }

  Future<void> toggleArticleBookmark(String articleId) async {
    final index = _discoverArticles.indexWhere((a) => a.id == articleId);
    if (index == -1) return;

    final article = _discoverArticles[index];
    final updatedArticle = article.copyWith(isBookmarked: !article.isBookmarked);
    
    _discoverArticles[index] = updatedArticle;
    notifyListeners();

    try {
      await _discoverService.toggleBookmark(articleId, updatedArticle.isBookmarked);
    } catch (e) {
      // Revert on error
      _discoverArticles[index] = article;
      notifyListeners();
      _setError('Failed to update bookmark: $e');
    }
  }

  Future<void> followTopic(String topic) async {
    if (_currentUser == null) return;

    final updatedTopics = [..._currentUser!.preferences.followedTopics, topic];
    final updatedPreferences = _currentUser!.preferences.copyWith(
      followedTopics: updatedTopics,
    );
    
    await updateUserPreferences(updatedPreferences);
  }

  Future<void> unfollowTopic(String topic) async {
    if (_currentUser == null) return;

    final updatedTopics = _currentUser!.preferences.followedTopics
        .where((t) => t != topic)
        .toList();
    final updatedPreferences = _currentUser!.preferences.copyWith(
      followedTopics: updatedTopics,
    );
    
    await updateUserPreferences(updatedPreferences);
  }

  // Theme methods
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    
    if (_currentUser != null) {
      final updatedPreferences = _currentUser!.preferences.copyWith(
        isDarkMode: _themeMode == ThemeMode.dark,
      );
      updateUserPreferences(updatedPreferences);
    }
  }

  void _updateThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Incognito mode
  void toggleIncognitoMode() {
    if (_currentUser == null) return;

    final updatedPreferences = _currentUser!.preferences.copyWith(
      isIncognitoMode: !_currentUser!.preferences.isIncognitoMode,
    );
    updateUserPreferences(updatedPreferences);
  }

  // Private methods
  Future<void> _loadUserPreferences() async {
    try {
      final user = await _userService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _updateThemeMode(user.preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);
      }
    } catch (e) {
      // User not signed in
    }
  }

  Future<void> _loadSearchHistory() async {
    if (isIncognitoMode) return;
    
    try {
      _searchHistory = await _userService.getSearchHistory();
      notifyListeners();
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _loadDiscoverFeed() async {
    await loadDiscoverFeed(refresh: true);
  }

  Future<void> _addToSearchHistory(String query) async {
    if (_searchHistory.contains(query)) {
      _searchHistory.remove(query);
    }
    _searchHistory.insert(0, query);
    
    // Keep only last 50 searches
    if (_searchHistory.length > 50) {
      _searchHistory = _searchHistory.take(50).toList();
    }
    
    await _userService.saveSearchHistory(_searchHistory);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}