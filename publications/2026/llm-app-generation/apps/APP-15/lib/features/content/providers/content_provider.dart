import 'package:flutter/foundation.dart';
import '../../../shared/models/content.dart';
import '../../../core/constants/app_constants.dart';

class ContentProvider extends ChangeNotifier {
  List<Content> _allContent = [];
  List<Content> _filteredContent = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  ContentType? _selectedType;
  ContentCategory? _selectedCategory;
  DifficultyLevel? _selectedDifficulty;
  String? _selectedPartner;

  // Getters
  List<Content> get allContent => _allContent;
  List<Content> get filteredContent => _filteredContent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  ContentProvider() {
    _initializeMockContent();
  }

  Future<void> loadContent() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, this would fetch from an API
      _initializeMockContent();
      _applyCurrentFilters();
    } catch (e) {
      _setError('Failed to load content. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  void searchContent(String query) {
    _searchQuery = query.toLowerCase();
    _applyCurrentFilters();
  }

  void filterByType(ContentType? type) {
    _selectedType = type;
    _applyCurrentFilters();
  }

  void applyFilters({
    ContentCategory? category,
    DifficultyLevel? difficulty,
    String? partner,
  }) {
    _selectedCategory = category;
    _selectedDifficulty = difficulty;
    _selectedPartner = partner;
    _applyCurrentFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedType = null;
    _selectedCategory = null;
    _selectedDifficulty = null;
    _selectedPartner = null;
    _applyCurrentFilters();
  }

  void _applyCurrentFilters() {
    _filteredContent = _allContent.where((content) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = content.title.toLowerCase().contains(_searchQuery) ||
            content.description.toLowerCase().contains(_searchQuery) ||
            content.tags.any((tag) => tag.toLowerCase().contains(_searchQuery));
        if (!matchesSearch) return false;
      }

      // Type filter
      if (_selectedType != null && content.type != _selectedType) {
        return false;
      }

      // Category filter
      if (_selectedCategory != null && content.category != _selectedCategory) {
        return false;
      }

      // Difficulty filter
      if (_selectedDifficulty != null && content.difficulty != _selectedDifficulty) {
        return false;
      }

      // Partner filter
      if (_selectedPartner != null && content.partner != _selectedPartner) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void _initializeMockContent() {
    _allContent = [
      Content(
        id: '1',
        title: '15-Minute HIIT Workout',
        description: 'High-intensity interval training to boost your metabolism and burn calories fast.',
        type: ContentType.video,
        thumbnailUrl: '',
        videoUrl: 'https://example.com/video1',
        durationMinutes: 15,
        category: ContentCategory.hiit,
        difficulty: DifficultyLevel.intermediate,
        partner: 'Aaptiv',
        tags: ['hiit', 'cardio', 'quick', 'fat-burn'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isFeatured: true,
        rating: 4.8,
        viewCount: 1250,
        instructorName: 'Sarah Johnson',
        equipment: 'None',
        targetMuscles: ['Full Body'],
      ),
      Content(
        id: '2',
        title: 'Morning Yoga Flow',
        description: 'Start your day with this gentle yoga sequence to awaken your body and mind.',
        type: ContentType.video,
        thumbnailUrl: '',
        videoUrl: 'https://example.com/video2',
        durationMinutes: 20,
        category: ContentCategory.yoga,
        difficulty: DifficultyLevel.beginner,
        partner: 'Daily Burn',
        tags: ['yoga', 'morning', 'flexibility', 'mindfulness'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isFeatured: true,
        rating: 4.9,
        viewCount: 2100,
        instructorName: 'Maya Patel',
        equipment: 'Yoga Mat',
        targetMuscles: ['Core', 'Back'],
      ),
      Content(
        id: '3',
        title: 'Strength Training Basics',
        description: 'Learn the fundamentals of strength training with proper form and technique.',
        type: ContentType.video,
        thumbnailUrl: '',
        videoUrl: 'https://example.com/video3',
        durationMinutes: 30,
        category: ContentCategory.strength,
        difficulty: DifficultyLevel.beginner,
        partner: 'Sworkit',
        tags: ['strength', 'basics', 'form', 'technique'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        rating: 4.7,
        viewCount: 890,
        instructorName: 'Mike Rodriguez',
        equipment: 'Dumbbells',
        targetMuscles: ['Arms', 'Chest', 'Back'],
      ),
      Content(
        id: '4',
        title: 'Meditation for Stress Relief',
        description: 'A guided meditation session to help you relax and reduce stress.',
        type: ContentType.audio,
        thumbnailUrl: '',
        audioUrl: 'https://example.com/audio1',
        durationMinutes: 10,
        category: ContentCategory.meditation,
        difficulty: DifficultyLevel.beginner,
        partner: 'Headspace',
        tags: ['meditation', 'stress', 'relaxation', 'mindfulness'],
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        rating: 4.6,
        viewCount: 1500,
        instructorName: 'Dr. Emma Wilson',
        equipment: 'None',
        targetMuscles: [],
      ),
      Content(
        id: '5',
        title: 'Healthy Smoothie Recipes',
        description: 'Delicious and nutritious smoothie recipes to fuel your workouts.',
        type: ContentType.article,
        thumbnailUrl: '',
        durationMinutes: 5,
        category: ContentCategory.nutrition,
        difficulty: DifficultyLevel.beginner,
        partner: 'Nike Training Club',
        tags: ['nutrition', 'smoothies', 'healthy', 'recipes'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        rating: 4.5,
        viewCount: 750,
        equipment: 'Blender',
        targetMuscles: [],
      ),
      Content(
        id: '6',
        title: 'Advanced Cardio Circuit',
        description: 'Challenge yourself with this high-intensity cardio circuit workout.',
        type: ContentType.video,
        thumbnailUrl: '',
        videoUrl: 'https://example.com/video4',
        durationMinutes: 25,
        category: ContentCategory.cardio,
        difficulty: DifficultyLevel.advanced,
        partner: 'Peloton Digital',
        tags: ['cardio', 'circuit', 'advanced', 'endurance'],
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 6)),
        rating: 4.8,
        viewCount: 980,
        instructorName: 'Alex Thompson',
        equipment: 'None',
        targetMuscles: ['Full Body'],
      ),
      Content(
        id: '7',
        title: 'Post-Workout Stretching',
        description: 'Essential stretches to help your muscles recover after a workout.',
        type: ContentType.video,
        thumbnailUrl: '',
        videoUrl: 'https://example.com/video5',
        durationMinutes: 12,
        category: ContentCategory.stretching,
        difficulty: DifficultyLevel.beginner,
        partner: 'Calm',
        tags: ['stretching', 'recovery', 'flexibility', 'cool-down'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        rating: 4.7,
        viewCount: 1200,
        instructorName: 'Lisa Chen',
        equipment: 'None',
        targetMuscles: ['Legs', 'Back', 'Arms'],
      ),
      Content(
        id: '8',
        title: 'Wellness Tips for Busy People',
        description: 'Simple wellness strategies you can incorporate into your busy lifestyle.',
        type: ContentType.article,
        thumbnailUrl: '',
        durationMinutes: 8,
        category: ContentCategory.wellness,
        difficulty: DifficultyLevel.beginner,
        partner: 'Daily Burn',
        tags: ['wellness', 'lifestyle', 'tips', 'busy'],
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
        rating: 4.4,
        viewCount: 650,
        targetMuscles: [],
      ),
    ];

    _filteredContent = List.from(_allContent);
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

  // Get featured content
  List<Content> get featuredContent {
    return _allContent.where((content) => content.isFeatured).toList();
  }

  // Get content by category
  List<Content> getContentByCategory(ContentCategory category) {
    return _allContent.where((content) => content.category == category).toList();
  }

  // Get content by partner
  List<Content> getContentByPartner(String partner) {
    return _allContent.where((content) => content.partner == partner).toList();
  }

  // Get recent content
  List<Content> get recentContent {
    final sortedContent = List<Content>.from(_allContent);
    sortedContent.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedContent.take(AppConstants.maxRecentContent).toList();
  }

  // Get popular content
  List<Content> get popularContent {
    final sortedContent = List<Content>.from(_allContent);
    sortedContent.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return sortedContent.take(10).toList();
  }
}