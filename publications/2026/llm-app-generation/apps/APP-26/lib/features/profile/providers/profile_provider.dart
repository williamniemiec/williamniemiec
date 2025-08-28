import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class ProfileProvider extends ChangeNotifier {
  User? _user;
  List<Post> _userPosts = [];
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  List<Post> get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserProfile(String username) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      _user = _generateMockUser(username);
      _userPosts = _generateMockUserPosts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  User _generateMockUser(String username) {
    return User(
      id: '1',
      username: username,
      displayName: 'Mock User',
      email: 'mock@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  List<Post> _generateMockUserPosts() {
    return [];
  }
}