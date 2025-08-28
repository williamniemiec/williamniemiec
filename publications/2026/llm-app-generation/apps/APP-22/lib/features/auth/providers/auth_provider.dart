import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user data
      _currentUser = User(
        id: '1',
        username: 'user123',
        displayName: 'John Doe',
        email: email,
        subscriptionType: SubscriptionType.premium,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastActiveAt: DateTime.now(),
      );
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    _setLoading(true);
    _error = null;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user creation
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: email.split('@').first,
        displayName: displayName,
        email: email,
        subscriptionType: SubscriptionType.free,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}