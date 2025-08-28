import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../shared/models/bet.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  // User State
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // App State
  bool _isDarkMode = false;
  String _selectedLanguage = 'pt_BR';
  double _balance = 0.0;

  // Bet Slip State
  BetSlip _betSlip = BetSlip.empty();
  bool _isBetSlipVisible = false;

  // Navigation State
  int _currentBottomNavIndex = 0;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  double get balance => _balance;
  BetSlip get betSlip => _betSlip;
  bool get isBetSlipVisible => _isBetSlipVisible;
  int get currentBottomNavIndex => _currentBottomNavIndex;

  // Formatted balance
  String get formattedBalance => 'R\$ ${_balance.toStringAsFixed(2)}';

  // User Authentication Methods
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user data
      _currentUser = User(
        id: '1',
        email: email,
        username: email.split('@')[0],
        firstName: 'João',
        lastName: 'Silva',
        cpf: '123.456.789-00',
        phone: '(11) 99999-9999',
        dateOfBirth: DateTime(1990, 1, 1),
        balance: 1000.0,
        isVerified: true,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now(),
        preferences: const UserPreferences(
          notificationsEnabled: true,
          biometricLoginEnabled: false,
          darkModeEnabled: false,
          favoriteSports: ['football', 'basketball'],
          preferredLanguage: 'pt_BR',
          preferredCurrency: 'BRL',
          liveStreamingEnabled: true,
          streamingQuality: 'high',
        ),
        responsibleGamingLimits: const ResponsibleGamingLimits(
          dailyDepositLimit: 1000.0,
          weeklyDepositLimit: 5000.0,
          monthlyDepositLimit: 20000.0,
          sessionTimeLimit: 240,
          isActive: true,
        ),
      );

      _isAuthenticated = true;
      _balance = _currentUser!.balance;
      _isDarkMode = _currentUser!.preferences.darkModeEnabled;
      _selectedLanguage = _currentUser!.preferences.preferredLanguage;
      
    } catch (e) {
      _setError('Erro ao fazer login: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String cpf,
    required String phone,
    required DateTime dateOfBirth,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful registration
      await login(email, password);
      
    } catch (e) {
      _setError('Erro ao criar conta: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    _balance = 0.0;
    _betSlip = BetSlip.empty();
    _isBetSlipVisible = false;
    _currentBottomNavIndex = 0;
    notifyListeners();
  }

  // Balance Methods
  Future<void> updateBalance(double newBalance) async {
    _balance = newBalance;
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(balance: newBalance);
    }
    notifyListeners();
  }

  Future<void> deposit(double amount) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newBalance = _balance + amount;
      await updateBalance(newBalance);
      
    } catch (e) {
      _setError('Erro ao fazer depósito: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> withdraw(double amount) async {
    _setLoading(true);
    _clearError();

    try {
      if (amount > _balance) {
        throw Exception('Saldo insuficiente');
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newBalance = _balance - amount;
      await updateBalance(newBalance);
      
    } catch (e) {
      _setError('Erro ao fazer saque: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Bet Slip Methods
  void addToBetSlip(BetSelection selection) {
    _betSlip = _betSlip.addSelection(selection);
    _isBetSlipVisible = true;
    notifyListeners();
  }

  void removeFromBetSlip(String selectionId) {
    _betSlip = _betSlip.removeSelection(selectionId);
    if (_betSlip.isEmpty) {
      _isBetSlipVisible = false;
    }
    notifyListeners();
  }

  void updateBetSlipStake(double stake) {
    _betSlip = _betSlip.updateStake(stake);
    notifyListeners();
  }

  void updateBetSlipType(BetType betType) {
    _betSlip = _betSlip.updateBetType(betType);
    notifyListeners();
  }

  void clearBetSlip() {
    _betSlip = BetSlip.empty();
    _isBetSlipVisible = false;
    notifyListeners();
  }

  void toggleBetSlipVisibility() {
    _isBetSlipVisible = !_isBetSlipVisible;
    notifyListeners();
  }

  Future<void> placeBet() async {
    if (!_betSlip.isValid || _betSlip.stake > _balance) {
      _setError('Aposta inválida ou saldo insuficiente');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Deduct stake from balance
      final newBalance = _balance - _betSlip.stake;
      await updateBalance(newBalance);
      
      // Clear bet slip
      clearBetSlip();
      
    } catch (e) {
      _setError('Erro ao fazer aposta: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Navigation Methods
  void setBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }

  // Settings Methods
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    if (_currentUser != null) {
      final newPreferences = _currentUser!.preferences.copyWith(
        darkModeEnabled: _isDarkMode,
      );
      _currentUser = _currentUser!.copyWith(preferences: newPreferences);
    }
    notifyListeners();
  }

  void updateLanguage(String language) {
    _selectedLanguage = language;
    if (_currentUser != null) {
      final newPreferences = _currentUser!.preferences.copyWith(
        preferredLanguage: language,
      );
      _currentUser = _currentUser!.copyWith(preferences: newPreferences);
    }
    notifyListeners();
  }

  void updateNotificationSettings(bool enabled) {
    if (_currentUser != null) {
      final newPreferences = _currentUser!.preferences.copyWith(
        notificationsEnabled: enabled,
      );
      _currentUser = _currentUser!.copyWith(preferences: newPreferences);
      notifyListeners();
    }
  }

  void updateBiometricSettings(bool enabled) {
    if (_currentUser != null) {
      final newPreferences = _currentUser!.preferences.copyWith(
        biometricLoginEnabled: enabled,
      );
      _currentUser = _currentUser!.copyWith(preferences: newPreferences);
      notifyListeners();
    }
  }

  void updateFavoriteSports(List<String> sports) {
    if (_currentUser != null) {
      final newPreferences = _currentUser!.preferences.copyWith(
        favoriteSports: sports,
      );
      _currentUser = _currentUser!.copyWith(preferences: newPreferences);
      notifyListeners();
    }
  }

  // Responsible Gaming Methods
  Future<void> updateResponsibleGamingLimits(ResponsibleGamingLimits limits) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(responsibleGamingLimits: limits);
        notifyListeners();
      }
      
    } catch (e) {
      _setError('Erro ao atualizar limites: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setSelfExclusion(DateTime until) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (_currentUser != null) {
        final newLimits = _currentUser!.responsibleGamingLimits.copyWith(
          selfExclusionUntil: until,
        );
        _currentUser = _currentUser!.copyWith(responsibleGamingLimits: newLimits);
        notifyListeners();
      }
      
    } catch (e) {
      _setError('Erro ao configurar autoexclusão: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Utility Methods
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

  void clearError() {
    _clearError();
  }

  // Check if user can place bets (not self-excluded, within limits, etc.)
  bool get canPlaceBets {
    if (!_isAuthenticated || _currentUser == null) return false;
    
    final limits = _currentUser!.responsibleGamingLimits;
    if (limits.isSelfExcluded) return false;
    
    return true;
  }

  // Check if user needs KYC verification
  bool get needsKycVerification {
    return _isAuthenticated && _currentUser != null && !_currentUser!.isVerified;
  }

  // Get user's favorite sports
  List<String> get favoriteSports {
    return _currentUser?.preferences.favoriteSports ?? AppConstants.popularSports;
  }

  // Check if notifications are enabled
  bool get notificationsEnabled {
    return _currentUser?.preferences.notificationsEnabled ?? true;
  }

  // Check if biometric login is enabled
  bool get biometricLoginEnabled {
    return _currentUser?.preferences.biometricLoginEnabled ?? false;
  }

  // Check if live streaming is enabled
  bool get liveStreamingEnabled {
    return _currentUser?.preferences.liveStreamingEnabled ?? true;
  }

  // Get streaming quality preference
  String get streamingQuality {
    return _currentUser?.preferences.streamingQuality ?? 'high';
  }
}