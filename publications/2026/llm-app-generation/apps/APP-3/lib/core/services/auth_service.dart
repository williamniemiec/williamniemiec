import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user.dart' as app_user;
import '../constants/app_constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final StreamController<app_user.User?> _userController = StreamController<app_user.User?>.broadcast();
  Stream<app_user.User?> get userStream => _userController.stream;
  
  app_user.User? _currentUser;
  app_user.User? get currentUser => _currentUser;
  
  bool get isAuthenticated => _currentUser != null;

  /// Initialize the authentication service
  Future<void> initialize() async {
    // Listen to Firebase Auth state changes
    _firebaseAuth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser);
      } else {
        _currentUser = null;
        _userController.add(null);
        await _clearUserData();
      }
    });

    // Check if user is already signed in
    final User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser);
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData(credential.user!);
        return AuthResult.success();
      } else {
        return AuthResult.failure('Sign in failed');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);
        
        // Create user profile
        final appUser = app_user.User(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _saveUserData(appUser);
        _currentUser = appUser;
        _userController.add(appUser);

        return AuthResult.success();
      } else {
        return AuthResult.failure('Sign up failed');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.failure('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _loadUserData(userCredential.user!);
        return AuthResult.success();
      } else {
        return AuthResult.failure('Google sign in failed');
      }
    } catch (e) {
      return AuthResult.failure('Google sign in failed: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _currentUser = null;
      _userController.add(null);
      await _clearUserData();
    } catch (e) {
      // Handle sign out error
      print('Sign out error: $e');
    }
  }

  /// Reset password
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getFirebaseErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Failed to send password reset email');
    }
  }

  /// Update user profile
  Future<AuthResult> updateUserProfile(app_user.User updatedUser) async {
    try {
      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return AuthResult.failure('User not authenticated');
      }

      // Update Firebase user profile
      await firebaseUser.updateDisplayName(updatedUser.displayName);
      if (updatedUser.profilePictureUrl != null) {
        await firebaseUser.updatePhotoURL(updatedUser.profilePictureUrl);
      }

      // Update local user data
      final updatedUserWithTimestamp = updatedUser.copyWith(
        updatedAt: DateTime.now(),
      );

      await _saveUserData(updatedUserWithTimestamp);
      _currentUser = updatedUserWithTimestamp;
      _userController.add(updatedUserWithTimestamp);

      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure('Failed to update profile');
    }
  }

  /// Update user status
  Future<void> updateUserStatus(app_user.UserStatus status, {String? statusMessage}) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(
      status: status,
      statusMessage: statusMessage,
      updatedAt: DateTime.now(),
    );

    await _saveUserData(updatedUser);
    _currentUser = updatedUser;
    _userController.add(updatedUser);
  }

  /// Set user online status
  Future<void> setUserOnline(bool isOnline) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(
      isOnline: isOnline,
      lastSeen: isOnline ? null : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveUserData(updatedUser);
    _currentUser = updatedUser;
    _userController.add(updatedUser);
  }

  /// Load user data from Firebase and local storage
  Future<void> _loadUserData(User firebaseUser) async {
    try {
      // Try to load from local storage first
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString(AppConstants.userDataKey);
      
      app_user.User appUser;
      
      if (userDataJson != null) {
        // Load from local storage
        final userData = Map<String, dynamic>.from(
          Uri.splitQueryString(userDataJson)
        );
        appUser = app_user.User.fromJson(userData);
      } else {
        // Create from Firebase user
        appUser = app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          profilePictureUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _saveUserData(appUser);
      }

      _currentUser = appUser;
      _userController.add(appUser);
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  /// Save user data to local storage
  Future<void> _saveUserData(app_user.User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = user.toJson().toString();
      await prefs.setString(AppConstants.userDataKey, userDataJson);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Clear user data from local storage
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userDataKey);
      await prefs.remove(AppConstants.userTokenKey);
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  /// Get Firebase error message
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not allowed.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  /// Dispose resources
  void dispose() {
    _userController.close();
  }
}

/// Authentication result class
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult._({required this.isSuccess, this.errorMessage});

  factory AuthResult.success() => AuthResult._(isSuccess: true);
  factory AuthResult.failure(String message) => AuthResult._(
    isSuccess: false, 
    errorMessage: message,
  );
}