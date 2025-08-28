import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../shared/models/user.dart';
import '../../shared/models/league.dart';

class AppProvider extends ChangeNotifier {
  // Theme Management
  ThemeMode _themeMode = ThemeMode.dark; // Sleeper uses dark theme by default
  
  // User State
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  
  // App State
  String? _selectedLeagueId;
  List<League> _userLeagues = [];
  String _selectedSport = 'nfl';
  
  // Error Handling
  String? _errorMessage;

  // Getters
  ThemeMode get themeMode => _themeMode;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get selectedLeagueId => _selectedLeagueId;
  List<League> get userLeagues => _userLeagues;
  String get selectedSport => _selectedSport;
  String? get errorMessage => _errorMessage;

  // Theme Methods
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // Authentication Methods
  void setUser(User user) {
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _selectedLeagueId = null;
    _userLeagues.clear();
    notifyListeners();
  }

  // Loading State
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // League Management
  void setSelectedLeague(String? leagueId) {
    _selectedLeagueId = leagueId;
    notifyListeners();
  }

  void setUserLeagues(List<League> leagues) {
    _userLeagues = leagues;
    notifyListeners();
  }

  void addLeague(League league) {
    _userLeagues.add(league);
    notifyListeners();
  }

  void updateLeague(League updatedLeague) {
    final index = _userLeagues.indexWhere((l) => l.id == updatedLeague.id);
    if (index != -1) {
      _userLeagues[index] = updatedLeague;
      notifyListeners();
    }
  }

  void removeLeague(String leagueId) {
    _userLeagues.removeWhere((l) => l.id == leagueId);
    if (_selectedLeagueId == leagueId) {
      _selectedLeagueId = null;
    }
    notifyListeners();
  }

  // Sport Selection
  void setSelectedSport(String sport) {
    if (AppConstants.supportedSports.contains(sport)) {
      _selectedSport = sport;
      notifyListeners();
    }
  }

  // Error Handling
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Utility Methods
  League? getLeagueById(String leagueId) {
    try {
      return _userLeagues.firstWhere((l) => l.id == leagueId);
    } catch (e) {
      return null;
    }
  }

  List<League> getLeaguesBySport(String sport) {
    return _userLeagues.where((l) => l.sport == sport).toList();
  }

  bool hasActiveLeagues() {
    return _userLeagues.any((l) => l.isInSeason || l.isDrafting);
  }

  bool hasCompletedLeagues() {
    return _userLeagues.any((l) => l.isComplete);
  }

  int get totalLeagues => _userLeagues.length;
  int get activeLeagues => _userLeagues.where((l) => l.isInSeason || l.isDrafting).length;
  int get draftingLeagues => _userLeagues.where((l) => l.isDrafting).length;

  // Initialize app state
  Future<void> initialize() async {
    setLoading(true);
    try {
      // TODO: Load user data from storage
      // TODO: Load user leagues
      // TODO: Check authentication status
      
      // Simulate loading
      await Future.delayed(const Duration(seconds: 1));
      
    } catch (e) {
      setError('Failed to initialize app: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  // Refresh app data
  Future<void> refresh() async {
    if (_isAuthenticated && _currentUser != null) {
      setLoading(true);
      try {
        // TODO: Refresh user leagues
        // TODO: Refresh user data
        
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        
      } catch (e) {
        setError('Failed to refresh data: ${e.toString()}');
      } finally {
        setLoading(false);
      }
    }
  }
}