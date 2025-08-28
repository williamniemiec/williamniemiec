import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class ProfileProvider extends ChangeNotifier {
  RedditUser? _user;
  List<RedditPost> _userPosts = [];
  List<RedditComment> _userComments = [];
  List<RedditPost> _savedPosts = [];
  bool _isLoading = false;
  String? _error;

  RedditUser? get user => _user;
  List<RedditPost> get userPosts => _userPosts;
  List<RedditComment> get userComments => _userComments;
  List<RedditPost> get savedPosts => _savedPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserProfile(String username) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      _user = RedditUser(
        id: 'user_$username',
        username: username,
        displayName: username,
        karma: 12345,
        commentKarma: 6789,
        linkKarma: 5556,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      );
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load profile: ${e.toString()}');
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}