import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/coloring_page.dart';
import '../models/user_progress.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

class ColoringProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  // Current coloring session
  ColoringPage? _currentPage;
  UserProgress? _currentProgress;
  int? _selectedColorNumber;
  List<int> _highlightedRegions = [];
  
  // Canvas state
  double _zoomLevel = 1.0;
  Offset _panOffset = Offset.zero;
  bool _isLoading = false;
  String? _error;
  
  // Session tracking
  DateTime? _sessionStartTime;
  int _sessionTimeMinutes = 0;

  // Getters
  ColoringPage? get currentPage => _currentPage;
  UserProgress? get currentProgress => _currentProgress;
  int? get selectedColorNumber => _selectedColorNumber;
  List<int> get highlightedRegions => _highlightedRegions;
  double get zoomLevel => _zoomLevel;
  Offset get panOffset => _panOffset;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get sessionTimeMinutes => _sessionTimeMinutes;
  
  bool get hasUnsavedProgress => _currentProgress != null && 
      _currentProgress!.progressPercentage > 0 && 
      !_currentProgress!.isCompleted;

  double get progressPercentage => _currentProgress?.progressPercentage ?? 0.0;
  bool get isCompleted => _currentProgress?.isCompleted ?? false;

  // Load a coloring page
  Future<void> loadColoringPage(String pageId) async {
    _setLoading(true);
    _clearError();

    try {
      // Load the coloring page
      final page = await _databaseService.getColoringPageById(pageId);
      if (page == null) {
        _setError('Coloring page not found');
        return;
      }

      // Load existing progress or create new
      final progress = await _databaseService.getUserProgress(pageId) ??
          UserProgress(
            pageId: pageId,
            coloredRegions: {},
            progressPercentage: 0.0,
            lastModified: DateTime.now(),
          );

      _currentPage = page;
      _currentProgress = progress;
      _selectedColorNumber = null;
      _highlightedRegions = [];
      _zoomLevel = 1.0;
      _panOffset = Offset.zero;
      _sessionStartTime = DateTime.now();

      // Add to recently viewed
      await _storageService.addRecentlyViewed(pageId);

      notifyListeners();
    } catch (e) {
      _setError('Failed to load coloring page: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Select a color from the palette
  void selectColor(int colorNumber) {
    if (_currentPage == null) return;

    _selectedColorNumber = colorNumber;
    
    // Find all regions with this color number
    _highlightedRegions = _currentPage!.regions
        .where((region) => region.number == colorNumber)
        .where((region) => !(_currentProgress?.coloredRegions[region.number] ?? false))
        .map((region) => region.number)
        .toList();

    notifyListeners();
  }

  // Color a region
  Future<void> colorRegion(int regionNumber) async {
    if (_currentPage == null || _currentProgress == null || _selectedColorNumber == null) {
      return;
    }

    // Check if this region matches the selected color
    final region = _currentPage!.regions.firstWhere(
      (r) => r.number == regionNumber,
      orElse: () => throw Exception('Region not found'),
    );

    if (region.number != _selectedColorNumber) {
      return; // Wrong color selected
    }

    // Update progress
    _currentProgress = _currentProgress!.markRegionColored(regionNumber);
    
    // Remove from highlighted regions
    _highlightedRegions.remove(regionNumber);

    // Save progress to database
    await _databaseService.saveUserProgress(_currentProgress!);

    // Check if completed
    if (_currentProgress!.isCompleted) {
      await _onColoringCompleted();
    }

    notifyListeners();
  }

  // Handle completion
  Future<void> _onColoringCompleted() async {
    if (_currentPage == null || _currentProgress == null) return;

    // Calculate session time
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      _sessionTimeMinutes = sessionDuration.inMinutes;
    }

    // Create user artwork
    final artwork = UserArtwork(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pageId: _currentPage!.id,
      title: _currentPage!.title,
      thumbnailPath: _currentPage!.thumbnailPath,
      completedImagePath: _currentPage!.imagePath, // In a real app, this would be the colored version
      completedAt: DateTime.now(),
      timeSpentMinutes: _sessionTimeMinutes,
    );

    await _databaseService.saveUserArtwork(artwork);
    await _storageService.incrementCompletedPages();
    await _storageService.addColoringTime(_sessionTimeMinutes);
  }

  // Canvas controls
  void updateZoom(double newZoom) {
    _zoomLevel = newZoom.clamp(0.5, 5.0);
    notifyListeners();
  }

  void updatePan(Offset newOffset) {
    _panOffset = newOffset;
    notifyListeners();
  }

  void resetCanvasTransform() {
    _zoomLevel = 1.0;
    _panOffset = Offset.zero;
    notifyListeners();
  }

  // Hint system
  void showHint() {
    if (_currentPage == null || _selectedColorNumber == null) return;

    // Find the first uncolored region for the selected color
    final uncoloredRegions = _currentPage!.regions
        .where((region) => region.number == _selectedColorNumber)
        .where((region) => !(_currentProgress?.coloredRegions[region.number] ?? false))
        .toList();

    if (uncoloredRegions.isNotEmpty) {
      final hintRegion = uncoloredRegions.first;
      _highlightedRegions = [hintRegion.number];
      
      // In a real implementation, you would also pan/zoom to show this region
      notifyListeners();
    }
  }

  // Auto-save progress
  Future<void> autoSave() async {
    if (_currentProgress != null && _storageService.getAutoSaveEnabled()) {
      await _databaseService.saveUserProgress(_currentProgress!);
    }
  }

  // Clear current session
  void clearSession() {
    _currentPage = null;
    _currentProgress = null;
    _selectedColorNumber = null;
    _highlightedRegions = [];
    _zoomLevel = 1.0;
    _panOffset = Offset.zero;
    _sessionStartTime = null;
    _sessionTimeMinutes = 0;
    _clearError();
    notifyListeners();
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

  // Get color for a region
  Color? getRegionColor(int regionNumber) {
    if (_currentPage == null) return null;
    
    final region = _currentPage!.regions.firstWhere(
      (r) => r.number == regionNumber,
      orElse: () => throw Exception('Region not found'),
    );

    // If region is colored, return the actual color
    if (_currentProgress?.coloredRegions[regionNumber] == true) {
      return Color(int.parse(region.colorCode.replaceFirst('#', '0xFF')));
    }

    // If region is highlighted, return a highlight color
    if (_highlightedRegions.contains(regionNumber)) {
      return Colors.yellow.withOpacity(0.5);
    }

    // Otherwise return null (transparent/uncolored)
    return null;
  }

  // Check if a region is colored
  bool isRegionColored(int regionNumber) {
    return _currentProgress?.coloredRegions[regionNumber] ?? false;
  }

  // Get available colors (not yet completed)
  List<ColorPalette> getAvailableColors() {
    if (_currentPage == null || _currentProgress == null) return [];

    return _currentPage!.palette.where((color) {
      // Check if there are any uncolored regions for this color
      return _currentPage!.regions
          .where((region) => region.number == color.number)
          .any((region) => !(_currentProgress!.coloredRegions[region.number] ?? false));
    }).toList();
  }

  // Get completed colors
  List<ColorPalette> getCompletedColors() {
    if (_currentPage == null || _currentProgress == null) return [];

    return _currentPage!.palette.where((color) {
      // Check if all regions for this color are completed
      final colorRegions = _currentPage!.regions
          .where((region) => region.number == color.number);
      
      return colorRegions.isNotEmpty && 
          colorRegions.every((region) => _currentProgress!.coloredRegions[region.number] ?? false);
    }).toList();
  }
}