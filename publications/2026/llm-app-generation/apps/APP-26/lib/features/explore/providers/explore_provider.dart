import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/api_service.dart';

class ExploreProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Trend> _trends = [];
  List<Post> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Trend> get trends => _trends;
  List<Post> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  ExploreProvider() {
    loadTrends();
  }

  Future<void> loadTrends() async {
    _setLoading(true);
    try {
      // Mock trends data
      await Future.delayed(const Duration(seconds: 1));
      _trends = _generateMockTrends();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _searchResults = _generateMockSearchResults(query);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  List<Trend> _generateMockTrends() {
    return [
      Trend(
        id: '1',
        name: '#Flutter',
        query: 'Flutter',
        postsCount: 125000,
        type: TrendType.hashtag,
        updatedAt: DateTime.now(),
        rank: 1,
        score: 95.5,
      ),
      Trend(
        id: '2',
        name: 'AI Revolution',
        query: 'AI Revolution',
        postsCount: 89000,
        type: TrendType.topic,
        updatedAt: DateTime.now(),
        rank: 2,
        score: 88.2,
      ),
    ];
  }

  List<Post> _generateMockSearchResults(String query) {
    // Mock search results
    return [];
  }
}