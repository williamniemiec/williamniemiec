import 'package:flutter/foundation.dart';
import '../models/coloring_page.dart';
import '../models/user_progress.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';

class LibraryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  // State
  List<ColoringPage> _allPages = [];
  List<ColoringPage> _filteredPages = [];
  List<UserProgress> _userProgress = [];
  String _selectedCategory = 'Featured';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ColoringPage> get allPages => _allPages;
  List<ColoringPage> get filteredPages => _filteredPages;
  List<UserProgress> get userProgress => _userProgress;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get categories => AppConstants.categories;

  // Initialize the library
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    try {
      // Load sample data if this is the first launch
      if (_storageService.getFirstLaunch()) {
        await _loadSampleData();
        await _storageService.setFirstLaunch(false);
      }

      // Load all coloring pages
      await loadColoringPages();
      
      // Load user progress
      await loadUserProgress();

      // Set last selected category
      _selectedCategory = _storageService.getLastSelectedCategory();
      _applyFilters();

    } catch (e) {
      _setError('Failed to initialize library: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load all coloring pages from database
  Future<void> loadColoringPages() async {
    try {
      _allPages = await _databaseService.getColoringPages();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load coloring pages: $e');
    }
  }

  // Load user progress
  Future<void> loadUserProgress() async {
    try {
      _userProgress = await _databaseService.getAllUserProgress();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user progress: $e');
    }
  }

  // Filter by category
  void selectCategory(String category) {
    _selectedCategory = category;
    _storageService.setLastSelectedCategory(category);
    _applyFilters();
    notifyListeners();
  }

  // Search functionality
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters and search
  void _applyFilters() {
    List<ColoringPage> filtered = List.from(_allPages);

    // Apply category filter
    if (_selectedCategory != 'Featured') {
      filtered = filtered.where((page) => page.category == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((page) => 
        page.title.toLowerCase().contains(query) ||
        page.category.toLowerCase().contains(query)
      ).toList();
    }

    // Sort by creation date (newest first) for Featured, or by title for others
    if (_selectedCategory == 'Featured') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }

    _filteredPages = filtered;
  }

  // Get progress for a specific page
  UserProgress? getProgressForPage(String pageId) {
    try {
      return _userProgress.firstWhere((progress) => progress.pageId == pageId);
    } catch (e) {
      return null;
    }
  }

  // Check if a page is in progress
  bool isPageInProgress(String pageId) {
    final progress = getProgressForPage(pageId);
    return progress != null && progress.progressPercentage > 0 && !progress.isCompleted;
  }

  // Check if a page is completed
  bool isPageCompleted(String pageId) {
    final progress = getProgressForPage(pageId);
    return progress?.isCompleted ?? false;
  }

  // Get progress percentage for a page
  double getProgressPercentage(String pageId) {
    final progress = getProgressForPage(pageId);
    return progress?.progressPercentage ?? 0.0;
  }

  // Get pages by status
  List<ColoringPage> getInProgressPages() {
    return _allPages.where((page) => isPageInProgress(page.id)).toList()
      ..sort((a, b) {
        final progressA = getProgressForPage(a.id);
        final progressB = getProgressForPage(b.id);
        return (progressB?.lastModified ?? DateTime(0))
            .compareTo(progressA?.lastModified ?? DateTime(0));
      });
  }

  List<ColoringPage> getCompletedPages() {
    return _allPages.where((page) => isPageCompleted(page.id)).toList()
      ..sort((a, b) {
        final progressA = getProgressForPage(a.id);
        final progressB = getProgressForPage(b.id);
        return (progressB?.lastModified ?? DateTime(0))
            .compareTo(progressA?.lastModified ?? DateTime(0));
      });
  }

  // Get recently viewed pages
  List<ColoringPage> getRecentlyViewedPages() {
    final recentlyViewedIds = _storageService.getRecentlyViewed();
    final pages = <ColoringPage>[];
    
    for (final pageId in recentlyViewedIds) {
      try {
        final page = _allPages.firstWhere((p) => p.id == pageId);
        pages.add(page);
      } catch (e) {
        // Page not found, skip
      }
    }
    
    return pages;
  }

  // Get favorite pages
  List<ColoringPage> getFavoritePages() {
    final favoriteIds = _storageService.getFavorites();
    final pages = <ColoringPage>[];
    
    for (final pageId in favoriteIds) {
      try {
        final page = _allPages.firstWhere((p) => p.id == pageId);
        pages.add(page);
      } catch (e) {
        // Page not found, skip
      }
    }
    
    return pages;
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String pageId) async {
    if (_storageService.isFavorite(pageId)) {
      await _storageService.removeFromFavorites(pageId);
    } else {
      await _storageService.addToFavorites(pageId);
    }
    notifyListeners();
  }

  // Check if page is favorite
  bool isFavorite(String pageId) {
    return _storageService.isFavorite(pageId);
  }

  // Get pages by difficulty
  List<ColoringPage> getPagesByDifficulty(int difficulty) {
    return _allPages.where((page) => page.difficulty == difficulty).toList();
  }

  // Get statistics
  Map<String, int> getStatistics() {
    final totalPages = _allPages.length;
    final completedPages = getCompletedPages().length;
    final inProgressPages = getInProgressPages().length;
    final favoritePages = getFavoritePages().length;

    return {
      'total': totalPages,
      'completed': completedPages,
      'inProgress': inProgressPages,
      'favorites': favoritePages,
    };
  }

  // Refresh library
  Future<void> refresh() async {
    await loadColoringPages();
    await loadUserProgress();
  }

  // Load sample data (for first launch)
  Future<void> _loadSampleData() async {
    final samplePages = _generateSamplePages();
    
    for (final page in samplePages) {
      await _databaseService.insertColoringPage(page);
    }
  }

  // Generate sample coloring pages
  List<ColoringPage> _generateSamplePages() {
    final now = DateTime.now();
    
    return [
      // Animals
      ColoringPage(
        id: 'animal_1',
        title: 'Cute Cat',
        category: 'Animals',
        imagePath: 'assets/coloring_pages/animal_cat.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/animal_cat_thumb.png',
        regions: _generateSampleRegions(15),
        palette: _generateSamplePalette(8),
        difficulty: 1,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      ColoringPage(
        id: 'animal_2',
        title: 'Majestic Lion',
        category: 'Animals',
        imagePath: 'assets/coloring_pages/animal_lion.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/animal_lion_thumb.png',
        regions: _generateSampleRegions(25),
        palette: _generateSamplePalette(12),
        difficulty: 2,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      
      // Mandalas
      ColoringPage(
        id: 'mandala_1',
        title: 'Simple Mandala',
        category: 'Mandalas',
        imagePath: 'assets/coloring_pages/mandala_simple.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/mandala_simple_thumb.png',
        regions: _generateSampleRegions(20),
        palette: _generateSamplePalette(10),
        difficulty: 2,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      ColoringPage(
        id: 'mandala_2',
        title: 'Complex Mandala',
        category: 'Mandalas',
        imagePath: 'assets/coloring_pages/mandala_complex.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/mandala_complex_thumb.png',
        regions: _generateSampleRegions(50),
        palette: _generateSamplePalette(20),
        difficulty: 4,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      
      // Floral
      ColoringPage(
        id: 'floral_1',
        title: 'Rose Garden',
        category: 'Floral',
        imagePath: 'assets/coloring_pages/floral_roses.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/floral_roses_thumb.png',
        regions: _generateSampleRegions(30),
        palette: _generateSamplePalette(15),
        difficulty: 2,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      
      // Nature
      ColoringPage(
        id: 'nature_1',
        title: 'Mountain Landscape',
        category: 'Nature',
        imagePath: 'assets/coloring_pages/nature_mountain.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/nature_mountain_thumb.png',
        regions: _generateSampleRegions(35),
        palette: _generateSamplePalette(18),
        difficulty: 3,
        createdAt: now.subtract(const Duration(days: 6)),
      ),
      
      // Fantasy
      ColoringPage(
        id: 'fantasy_1',
        title: 'Magical Unicorn',
        category: 'Fantasy',
        imagePath: 'assets/coloring_pages/fantasy_unicorn.svg',
        thumbnailPath: 'assets/coloring_pages/thumbs/fantasy_unicorn_thumb.png',
        regions: _generateSampleRegions(40),
        palette: _generateSamplePalette(16),
        difficulty: 3,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  List<ColorRegion> _generateSampleRegions(int count) {
    final regions = <ColorRegion>[];
    final colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7', '#DDA0DD', '#98D8C8', '#F7DC6F'];
    
    for (int i = 1; i <= count; i++) {
      regions.add(ColorRegion(
        number: i,
        coordinates: [[100, 100], [200, 100], [200, 200], [100, 200]], // Sample rectangle
        colorCode: colors[i % colors.length],
      ));
    }
    
    return regions;
  }

  List<ColorPalette> _generateSamplePalette(int count) {
    final palette = <ColorPalette>[];
    final colors = [
      {'code': '#FF6B6B', 'name': 'Coral Red'},
      {'code': '#4ECDC4', 'name': 'Turquoise'},
      {'code': '#45B7D1', 'name': 'Sky Blue'},
      {'code': '#96CEB4', 'name': 'Mint Green'},
      {'code': '#FFEAA7', 'name': 'Sunny Yellow'},
      {'code': '#DDA0DD', 'name': 'Plum Purple'},
      {'code': '#98D8C8', 'name': 'Seafoam'},
      {'code': '#F7DC6F', 'name': 'Golden Yellow'},
      {'code': '#BB8FCE', 'name': 'Lavender'},
      {'code': '#85C1E9', 'name': 'Light Blue'},
      {'code': '#F8C471', 'name': 'Peach'},
      {'code': '#82E0AA', 'name': 'Light Green'},
      {'code': '#F1948A', 'name': 'Salmon Pink'},
      {'code': '#85929E', 'name': 'Cool Gray'},
      {'code': '#D7BDE2', 'name': 'Soft Purple'},
      {'code': '#A9DFBF', 'name': 'Pale Green'},
      {'code': '#F9E79F', 'name': 'Cream Yellow'},
      {'code': '#AED6F1', 'name': 'Baby Blue'},
      {'code': '#FADBD8', 'name': 'Blush Pink'},
      {'code': '#D5DBDB', 'name': 'Light Gray'},
    ];
    
    for (int i = 1; i <= count && i <= colors.length; i++) {
      palette.add(ColorPalette(
        number: i,
        colorCode: colors[i - 1]['code']!,
        colorName: colors[i - 1]['name']!,
      ));
    }
    
    return palette;
  }

  // Utility methods
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
  }
}