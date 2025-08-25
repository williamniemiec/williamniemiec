import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/models/user.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Current User Provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.userStream;
});

// Authentication State Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthState.initial()) {
    _init();
  }

  void _init() async {
    await _authService.initialize();
    
    // Listen to user stream
    _authService.userStream.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    
    final result = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      // State will be updated by the user stream listener
    } else {
      state = AuthState.error(result.errorMessage ?? 'Sign in failed');
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthState.loading();
    
    final result = await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result.isSuccess) {
      // State will be updated by the user stream listener
    } else {
      state = AuthState.error(result.errorMessage ?? 'Sign up failed');
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    
    final result = await _authService.signInWithGoogle();

    if (result.isSuccess) {
      // State will be updated by the user stream listener
    } else {
      state = AuthState.error(result.errorMessage ?? 'Google sign in failed');
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = const AuthState.loading();
    await _authService.signOut();
    state = const AuthState.unauthenticated();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    final result = await _authService.resetPassword(email);
    return result.isSuccess;
  }

  // Update user profile
  Future<bool> updateUserProfile(User updatedUser) async {
    final result = await _authService.updateUserProfile(updatedUser);
    return result.isSuccess;
  }

  // Update user status
  Future<void> updateUserStatus(UserStatus status, {String? statusMessage}) async {
    await _authService.updateUserStatus(status, statusMessage: statusMessage);
  }

  // Set user online status
  Future<void> setUserOnline(bool isOnline) async {
    await _authService.setUserOnline(isOnline);
  }

  // Clear error state
  void clearError() {
    if (state is AuthStateError) {
      if (_authService.isAuthenticated) {
        state = AuthState.authenticated(_authService.currentUser!);
      } else {
        state = const AuthState.unauthenticated();
      }
    }
  }
}

// Auth State Classes
abstract class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.error(String message) = AuthStateError;
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}

// Helper providers for specific auth states
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthStateAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthStateLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthStateError ? authState.message : null;
});

// User Status Provider
final userStatusProvider = StateNotifierProvider<UserStatusNotifier, UserStatus>((ref) {
  final user = ref.watch(currentUserProvider).value;
  return UserStatusNotifier(user?.status ?? UserStatus.offline);
});

class UserStatusNotifier extends StateNotifier<UserStatus> {
  UserStatusNotifier(UserStatus initialStatus) : super(initialStatus);

  void updateStatus(UserStatus newStatus) {
    state = newStatus;
  }
}