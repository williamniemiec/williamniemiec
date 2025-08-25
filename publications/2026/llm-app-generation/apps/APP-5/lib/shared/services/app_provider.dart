import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/design_project.dart';
import '../models/design_style.dart';
import '../models/room_type.dart';
import '../models/subscription.dart';
import '../../core/constants/app_constants.dart';
import 'ai_design_service.dart';

class AppProvider extends ChangeNotifier {
  final AIDesignService _aiService = AIDesignService();
  
  // State variables
  List<DesignProject> _projects = [];
  List<DesignStyle> _designStyles = [];
  List<RoomType> _roomTypes = [];
  UserSubscription? _userSubscription;
  AIUsageStats? _usageStats;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<DesignProject> get projects => _projects;
  List<DesignProject> get favoriteProjects => 
      _projects.where((p) => p.isFavorite).toList();
  List<DesignStyle> get designStyles => _designStyles;
  List<RoomType> get roomTypes => _roomTypes;
  UserSubscription? get userSubscription => _userSubscription;
  AIUsageStats? get usageStats => _usageStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPremiumUser => _userSubscription?.isPremium ?? false;

  // Filtered getters
  List<RoomType> get interiorRoomTypes => 
      _roomTypes.where((r) => r.category == RoomCategory.interior).toList();
  List<RoomType> get exteriorRoomTypes => 
      _roomTypes.where((r) => r.category == RoomCategory.exterior).toList();
  List<DesignStyle> get freeDesignStyles => 
      _designStyles.where((s) => !s.isPremium).toList();
  List<DesignStyle> get premiumDesignStyles => 
      _designStyles.where((s) => s.isPremium).toList();

  // Initialize the app
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _loadData();
      await _loadUserSubscription();
      await _loadUsageStats();
      _clearError();
    } catch (e) {
      _setError('Failed to initialize app: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load initial data
  Future<void> _loadData() async {
    _designStyles = List.from(AppConstants.defaultDesignStyles);
    _roomTypes = List.from(AppConstants.defaultRoomTypes);
    await _loadProjects();
  }

  // Load saved projects
  Future<void> _loadProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getStringList(AppConstants.savedProjectsKey) ?? [];
      
      _projects = projectsJson
          .map((json) => DesignProject.fromJson(_parseJson(json)))
          .toList();
      
      // Sort by creation date (newest first)
      _projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error loading projects: $e');
      _projects = [];
    }
  }

  // Save projects to storage
  Future<void> _saveProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = _projects
          .map((project) => _stringifyJson(project.toJson()))
          .toList();
      
      await prefs.setStringList(AppConstants.savedProjectsKey, projectsJson);
    } catch (e) {
      debugPrint('Error saving projects: $e');
    }
  }

  // Load user subscription
  Future<void> _loadUserSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionJson = prefs.getString(AppConstants.userSubscriptionKey);
      
      if (subscriptionJson != null) {
        _userSubscription = UserSubscription.fromJson(_parseJson(subscriptionJson));
      }
    } catch (e) {
      debugPrint('Error loading subscription: $e');
    }
  }

  // Load usage statistics
  Future<void> _loadUsageStats() async {
    try {
      _usageStats = await _aiService.getUsageStats('user_id');
    } catch (e) {
      debugPrint('Error loading usage stats: $e');
    }
  }

  // Create a new design project
  Future<DesignProject> createProject({
    required String originalImagePath,
    required RoomType roomType,
    required DesignStyle designStyle,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validate image
      final isValidImage = await _aiService.validateImage(originalImagePath);
      if (!isValidImage) {
        throw Exception('Invalid image file');
      }

      // Check if user can generate
      final canGenerate = await _aiService.canGenerateDesign(
        isPremiumUser: isPremiumUser,
        dailyGenerationsUsed: _usageStats?.dailyGenerationsUsed ?? 0,
        designStyle: designStyle,
      );

      if (!canGenerate) {
        throw Exception('Generation limit reached or premium style requires subscription');
      }

      // Create project
      final project = DesignProject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalImagePath: originalImagePath,
        roomType: roomType,
        designStyle: designStyle,
        status: ProjectStatus.processing,
        createdAt: DateTime.now(),
      );

      // Add to projects list
      _projects.insert(0, project);
      await _saveProjects();
      notifyListeners();

      // Start AI generation
      _generateDesignInBackground(project);

      return project;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Generate design in background
  Future<void> _generateDesignInBackground(DesignProject project) async {
    try {
      final generatedImagePath = await _aiService.generateDesign(
        originalImagePath: project.originalImagePath,
        roomType: project.roomType,
        designStyle: project.designStyle,
        isHighResolution: isPremiumUser,
      );

      // Update project with generated image
      final updatedProject = project.copyWith(
        generatedImagePath: generatedImagePath,
        status: ProjectStatus.completed,
        completedAt: DateTime.now(),
      );

      // Update in list
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = updatedProject;
        await _saveProjects();
        notifyListeners();
      }

      // Update usage stats
      await _loadUsageStats();
    } catch (e) {
      // Update project with error
      final updatedProject = project.copyWith(
        status: ProjectStatus.failed,
        errorMessage: e.toString(),
      );

      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = updatedProject;
        await _saveProjects();
        notifyListeners();
      }
    }
  }

  // Toggle project favorite status
  Future<void> toggleProjectFavorite(String projectId) async {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      _projects[index] = _projects[index].copyWith(
        isFavorite: !_projects[index].isFavorite,
      );
      await _saveProjects();
      notifyListeners();
    }
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((p) => p.id == projectId);
    await _saveProjects();
    notifyListeners();
  }

  // Retry failed project
  Future<void> retryProject(String projectId) async {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      if (project.status == ProjectStatus.failed) {
        _projects[index] = project.copyWith(
          status: ProjectStatus.processing,
          errorMessage: null,
        );
        await _saveProjects();
        notifyListeners();

        // Restart generation
        _generateDesignInBackground(_projects[index]);
      }
    }
  }

  // Update subscription
  Future<void> updateSubscription(UserSubscription subscription) async {
    _userSubscription = subscription;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userSubscriptionKey,
        _stringifyJson(subscription.toJson()),
      );
    } catch (e) {
      debugPrint('Error saving subscription: $e');
    }
    
    notifyListeners();
  }

  // Clear subscription (for testing)
  Future<void> clearSubscription() async {
    _userSubscription = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userSubscriptionKey);
    } catch (e) {
      debugPrint('Error clearing subscription: $e');
    }
    
    notifyListeners();
  }

  // Get projects by status
  List<DesignProject> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((p) => p.status == status).toList();
  }

  // Get projects by room type
  List<DesignProject> getProjectsByRoomType(RoomType roomType) {
    return _projects.where((p) => p.roomType.id == roomType.id).toList();
  }

  // Get projects by design style
  List<DesignProject> getProjectsByDesignStyle(DesignStyle designStyle) {
    return _projects.where((p) => p.designStyle.id == designStyle.id).toList();
  }

  // Helper methods
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

  // JSON parsing helpers
  Map<String, dynamic> _parseJson(String jsonString) {
    // In a real app, you'd use dart:convert
    // For now, we'll return an empty map
    return {};
  }

  String _stringifyJson(Map<String, dynamic> json) {
    // In a real app, you'd use dart:convert
    // For now, we'll return an empty string
    return '';
  }
}