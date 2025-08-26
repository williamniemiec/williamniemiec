import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/membership.dart';
import '../../../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  
  User? _currentUser;
  Membership? _currentMembership;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  Membership? get currentMembership => _currentMembership;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  firebase_auth.User? get firebaseUser => _firebaseAuth.currentUser;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _setLoading(true);
    
    try {
      // Check if user is already signed in with Firebase
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await _loadUserData();
      }
      
      // Listen to auth state changes
      _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser != null) {
      await _loadUserData();
    } else {
      await _clearUserData();
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData();
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user profile
        final user = User(
          id: credential.user!.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          membershipId: _generateMembershipId(),
          membershipType: MembershipType.basic,
          memberSince: DateTime.now(),
          fitnessGoals: [],
          guestPassesRemaining: AppConstants.guestPassLimits['basic']!,
        );

        // Create basic membership
        final membership = Membership(
          id: user.membershipId,
          userId: user.id,
          plan: MembershipPlan.basic,
          status: MembershipStatus.active,
          startDate: DateTime.now(),
          nextBillingDate: DateTime.now().add(const Duration(days: 30)),
          monthlyFee: AppConstants.membershipPrices['basic']!,
          paymentMethod: PaymentMethod.creditCard,
          includedLocations: ['all'],
          guestPassesPerMonth: AppConstants.guestPassLimits['basic']!,
        );

        await _saveUserData(user, membership);
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseAuth.signOut();
      await _clearUserData();
      return true;
    } catch (e) {
      _setError('Failed to sign out. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Failed to send password reset email. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    List<String>? fitnessGoals,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final updatedUser = _currentUser!.copyWith(
        firstName: firstName ?? _currentUser!.firstName,
        lastName: lastName ?? _currentUser!.lastName,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        fitnessGoals: fitnessGoals ?? _currentUser!.fitnessGoals,
      );

      await _saveUserData(updatedUser, _currentMembership);
      return true;
    } catch (e) {
      _setError('Failed to update profile. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMembership(Membership membership) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await _saveUserData(_currentUser!, membership);
      return true;
    } catch (e) {
      _setError('Failed to update membership. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userBox = await Hive.openBox<User>(AppConstants.userBox);
      final membershipBox = await Hive.openBox<Membership>(AppConstants.membershipBox);
      
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        _currentUser = userBox.get(firebaseUser.uid);
        if (_currentUser != null) {
          _currentMembership = membershipBox.get(_currentUser!.membershipId);
        }
        _isAuthenticated = _currentUser != null;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
    notifyListeners();
  }

  Future<void> _saveUserData(User user, Membership? membership) async {
    try {
      final userBox = await Hive.openBox<User>(AppConstants.userBox);
      final membershipBox = await Hive.openBox<Membership>(AppConstants.membershipBox);
      
      await userBox.put(user.id, user);
      if (membership != null) {
        await membershipBox.put(membership.id, membership);
      }
      
      _currentUser = user;
      _currentMembership = membership;
      _isAuthenticated = true;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      throw Exception('Failed to save user data');
    }
    notifyListeners();
  }

  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.authTokenKey);
      await prefs.remove(AppConstants.refreshTokenKey);
      
      _currentUser = null;
      _currentMembership = null;
      _isAuthenticated = false;
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
    notifyListeners();
  }

  String _generateMembershipId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${AppConstants.barcodePrefix}$random';
  }

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
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

  // Check if user can bring guests
  bool canBringGuest() {
    return _currentUser?.canBringGuest ?? false;
  }

  // Get remaining guest passes
  int getRemainingGuestPasses() {
    return _currentUser?.guestPassesRemaining ?? 0;
  }

  // Update guest passes count
  Future<bool> updateGuestPassesCount(int newCount) async {
    if (_currentUser == null) return false;

    try {
      final updatedUser = _currentUser!.copyWith(
        guestPassesRemaining: newCount,
      );
      await _saveUserData(updatedUser, _currentMembership);
      return true;
    } catch (e) {
      _setError('Failed to update guest passes count.');
      return false;
    }
  }

  // Update last check-in time
  Future<bool> updateLastCheckIn() async {
    if (_currentUser == null) return false;

    try {
      final updatedUser = _currentUser!.copyWith(
        lastCheckIn: DateTime.now(),
      );
      await _saveUserData(updatedUser, _currentMembership);
      return true;
    } catch (e) {
      _setError('Failed to update check-in time.');
      return false;
    }
  }
}