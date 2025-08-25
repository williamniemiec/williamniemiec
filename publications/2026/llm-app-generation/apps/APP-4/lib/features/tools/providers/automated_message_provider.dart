import 'package:flutter/foundation.dart';
import '../../../shared/models/automated_message.dart';
import '../../../core/constants/app_constants.dart';

class AutomatedMessageProvider extends ChangeNotifier {
  List<AutomatedMessage> _automatedMessages = [];
  List<QuickReply> _quickReplies = [];
  bool _isLoading = false;
  String? _error;

  List<AutomatedMessage> get automatedMessages => _automatedMessages;
  List<QuickReply> get quickReplies => _quickReplies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAutomatedMessages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load default automated messages
      _automatedMessages = _getDefaultAutomatedMessages();
      _quickReplies = _getDefaultQuickReplies();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAutomatedMessage(AutomatedMessage message) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final index = _automatedMessages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        _automatedMessages[index] = message.copyWith(updatedAt: DateTime.now());
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addQuickReply(QuickReply quickReply) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      _quickReplies.add(quickReply);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateQuickReply(QuickReply quickReply) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final index = _quickReplies.indexWhere((q) => q.id == quickReply.id);
      if (index != -1) {
        _quickReplies[index] = quickReply;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuickReply(String quickReplyId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      _quickReplies.removeWhere((q) => q.id == quickReplyId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  AutomatedMessage? getGreetingMessage() {
    try {
      return _automatedMessages.firstWhere(
        (m) => m.type == AutomatedMessageType.greeting,
      );
    } catch (e) {
      return null;
    }
  }

  AutomatedMessage? getAwayMessage() {
    try {
      return _automatedMessages.firstWhere(
        (m) => m.type == AutomatedMessageType.away,
      );
    } catch (e) {
      return null;
    }
  }

  QuickReply? getQuickReplyByShortcut(String shortcut) {
    try {
      return _quickReplies.firstWhere((q) => q.shortcut == shortcut);
    } catch (e) {
      return null;
    }
  }

  List<AutomatedMessage> _getDefaultAutomatedMessages() {
    final now = DateTime.now();
    return [
      AutomatedMessage(
        id: 'greeting_1',
        type: AutomatedMessageType.greeting,
        content: AppConstants.defaultGreetingMessage,
        isEnabled: true,
        createdAt: now,
        updatedAt: now,
      ),
      AutomatedMessage(
        id: 'away_1',
        type: AutomatedMessageType.away,
        content: AppConstants.defaultAwayMessage,
        isEnabled: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  List<QuickReply> _getDefaultQuickReplies() {
    final now = DateTime.now();
    return AppConstants.defaultQuickReplies.entries.map((entry) {
      return QuickReply(
        id: 'quick_${entry.key.replaceAll('/', '')}',
        shortcut: entry.key,
        message: entry.value,
        createdAt: now,
      );
    }).toList();
  }
}