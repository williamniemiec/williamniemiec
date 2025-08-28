import 'package:flutter/foundation.dart';
import '../../../shared/models/message.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Message> get messages => _messages;
  List<Message> get unreadMessages => 
      _messages.where((msg) => msg.isUnread).toList();
  int get unreadCount => unreadMessages.length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _messages = [
        Message(
          id: '1',
          threadId: 'thread1',
          senderId: 'dr1',
          senderName: 'Dr. Sarah Johnson',
          senderRole: 'doctor',
          recipientId: '1',
          subject: 'Test Results Available',
          content: 'Your recent blood work results are now available in your health record.',
          sentAt: DateTime.now().subtract(const Duration(hours: 2)),
          isFromProvider: true,
          priority: MessagePriority.normal,
        ),
        Message(
          id: '2',
          threadId: 'thread2',
          senderId: 'nurse1',
          senderName: 'Nurse Jennifer Smith',
          senderRole: 'nurse',
          recipientId: '1',
          subject: 'Appointment Reminder',
          content: 'This is a reminder for your upcoming appointment on Friday.',
          sentAt: DateTime.now().subtract(const Duration(days: 1)),
          status: MessageStatus.read,
          isFromProvider: true,
          priority: MessagePriority.normal,
        ),
      ];
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load messages';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendMessage(String subject, String content, String recipientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        threadId: 'thread_${DateTime.now().millisecondsSinceEpoch}',
        senderId: '1',
        senderName: 'John Doe',
        senderRole: 'patient',
        recipientId: recipientId,
        subject: subject,
        content: content,
        sentAt: DateTime.now(),
        status: MessageStatus.read,
        isFromProvider: false,
      );
      
      _messages.insert(0, newMessage);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to send message';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void markAsRead(String messageId) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(status: MessageStatus.read);
      notifyListeners();
    }
  }
}