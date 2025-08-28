import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class NotificationsProvider extends ChangeNotifier {
  List<XNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<XNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NotificationsProvider() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      _notifications = _generateMockNotifications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<XNotification> _generateMockNotifications() {
    return [
      XNotification(
        id: '1',
        userId: '1',
        type: NotificationType.like,
        title: 'New Like',
        message: 'Someone liked your post',
        createdAt: DateTime.now(),
      ),
    ];
  }
}