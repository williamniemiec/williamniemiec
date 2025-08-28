import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';

class MessagesProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  bool _isLoading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MessagesProvider() {
    loadConversations();
  }

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      _conversations = _generateMockConversations();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Conversation> _generateMockConversations() {
    return [
      Conversation(
        id: '1',
        participantIds: ['1', '2'],
        participants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}