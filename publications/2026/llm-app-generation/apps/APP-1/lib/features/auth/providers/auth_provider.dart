import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user.dart';

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful authentication
      if (email.isNotEmpty && password.length >= 6) {
        final user = User(
          id: 'user_123',
          email: email,
          name: 'John Doe',
          membershipType: MembershipType.premiumPlus,
          creditsRemaining: 1,
          membershipExpiry: DateTime.now().add(const Duration(days: 30)),
          preferences: const UserPreferences(),
          stats: const UserStats(
            totalListeningTime: Duration(hours: 120),
            booksCompleted: 15,
            podcastsListened: 8,
            badges: ['Early Bird', 'Bookworm'],
            currentStreak: 7,
            longestStreak: 21,
          ),
        );
        
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid credentials',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: 'google_user_123',
        email: 'user@gmail.com',
        name: 'Google User',
        membershipType: MembershipType.plus,
        creditsRemaining: 0,
        membershipExpiry: DateTime.now().add(const Duration(days: 30)),
        preferences: const UserPreferences(),
        stats: const UserStats(
          totalListeningTime: Duration(hours: 45),
          booksCompleted: 5,
          podcastsListened: 12,
          badges: ['New Member'],
          currentStreak: 3,
          longestStreak: 10,
        ),
      );
      
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate Apple Sign In
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: 'apple_user_123',
        email: 'user@icloud.com',
        name: 'Apple User',
        membershipType: MembershipType.premiumPlus,
        creditsRemaining: 2,
        membershipExpiry: DateTime.now().add(const Duration(days: 365)),
        preferences: const UserPreferences(),
        stats: const UserStats(
          totalListeningTime: Duration(hours: 200),
          booksCompleted: 25,
          podcastsListened: 15,
          badges: ['Premium Member', 'Loyal Listener'],
          currentStreak: 14,
          longestStreak: 30,
        ),
      );
      
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Simulate sign out process
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final user = User(
        id: 'new_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        membershipType: MembershipType.free,
        creditsRemaining: 0,
        membershipExpiry: DateTime.now().add(const Duration(days: 30)),
        preferences: const UserPreferences(),
        stats: const UserStats(
          totalListeningTime: Duration.zero,
          booksCompleted: 0,
          podcastsListened: 0,
          badges: ['New Member'],
          currentStreak: 0,
          longestStreak: 0,
        ),
      );
      
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});