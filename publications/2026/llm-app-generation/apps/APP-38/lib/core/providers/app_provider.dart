import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../shared/models/search.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/property_service.dart';
import '../../shared/services/booking_service.dart';

class AppProvider extends ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final PropertyService _propertyService = PropertyService();
  final BookingService _bookingService = BookingService();

  // State
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  
  // User state
  User? _currentUser;
  bool _isAuthenticated = false;

  // Search state
  SearchCriteria? _currentSearchCriteria;
  List<RecentSearch> _recentSearches = [];

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  SearchCriteria? get currentSearchCriteria => _currentSearchCriteria;
  List<RecentSearch> get recentSearches => _recentSearches;

  // Service getters
  AuthService get authService => _authService;
  PropertyService get propertyService => _propertyService;
  BookingService get bookingService => _bookingService;

  // Initialize the app
  Future<void> initialize() async {
    if (_isInitialized) return;

    _setLoading(true);
    _clearError();

    try {
      // Initialize services
      await _authService.initialize();
      await _propertyService.initialize();
      await _bookingService.initialize();

      // Update authentication state
      _currentUser = _authService.currentUser;
      _isAuthenticated = _authService.isAuthenticated;

      // Load recent searches
      await _loadRecentSearches();

      _isInitialized = true;
    } catch (e) {
      _setError('Failed to initialize app: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Authentication methods
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.signIn(email, password);
      
      if (result.isSuccess) {
        _currentUser = result.user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        _setError(result.error ?? 'Sign in failed');
        return false;
      }
    } catch (e) {
      _setError('Sign in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      
      if (result.isSuccess) {
        _currentUser = result.user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        _setError(result.error ?? 'Sign up failed');
        return false;
      }
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      _currentSearchCriteria = null;
      _recentSearches.clear();
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(User updatedUser) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.updateProfile(updatedUser);
      
      if (result.isSuccess) {
        _currentUser = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.error ?? 'Profile update failed');
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search methods
  void updateSearchCriteria(SearchCriteria criteria) {
    _currentSearchCriteria = criteria;
    _addToRecentSearches(criteria);
    notifyListeners();
  }

  void clearSearchCriteria() {
    _currentSearchCriteria = null;
    notifyListeners();
  }

  void _addToRecentSearches(SearchCriteria criteria) {
    final recentSearch = RecentSearch(
      destination: criteria.destination,
      searchDate: DateTime.now(),
      serviceType: criteria.serviceType,
    );

    // Remove if already exists
    _recentSearches.removeWhere((search) => 
      search.destination == recentSearch.destination &&
      search.serviceType == recentSearch.serviceType
    );

    // Add to beginning
    _recentSearches.insert(0, recentSearch);

    // Keep only last 10 searches
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }

    _saveRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    // In a real app, this would load from SharedPreferences
    // For now, we'll keep it empty and populate as user searches
  }

  Future<void> _saveRecentSearches() async {
    // In a real app, this would save to SharedPreferences
    // For now, we'll just keep in memory
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    _saveRecentSearches();
    notifyListeners();
  }

  // Utility methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void _clearError() {
    _setError(null);
  }

  void clearError() {
    _clearError();
  }

  // Refresh methods
  Future<void> refresh() async {
    if (!_isInitialized) {
      await initialize();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      // Refresh user data if authenticated
      if (_isAuthenticated && _authService.authToken != null) {
        final isValid = await _authService.validateToken();
        if (!isValid) {
          await signOut();
          return;
        }
      }

      // Refresh other data as needed
      // This could include refreshing property data, bookings, etc.
      
    } catch (e) {
      _setError('Refresh failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Theme and preferences
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      // Save to preferences
    }
  }

  // Connectivity and app state
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void setOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}