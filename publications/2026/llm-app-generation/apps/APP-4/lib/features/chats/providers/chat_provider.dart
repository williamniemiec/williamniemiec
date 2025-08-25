import 'package:flutter/foundation.dart';
import '../../../shared/models/chat.dart';
import '../../../shared/models/label.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> _chats = [];
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Chat> get chats => _chats;
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load sample chats for demonstration
      _chats = _getSampleChats();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load sample messages for demonstration
      _messages = _getSampleMessages(chatId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String chatId, String content, MessageType type) async {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: 'business',
        content: content,
        type: type,
        status: MessageStatus.sending,
        timestamp: DateTime.now(),
        isFromBusiness: true,
      );

      _messages.add(message);
      notifyListeners();

      // Simulate sending delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Update message status
      final index = _messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        _messages[index] = message.copyWith(status: MessageStatus.sent);
        notifyListeners();
      }

      // Update chat's last message
      final chatIndex = _chats.indexWhere((c) => c.id == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          lastMessage: content,
          lastMessageTime: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void applyLabelToChat(String chatId, String labelId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final chat = _chats[chatIndex];
      final updatedLabels = List<String>.from(chat.labels);
      
      if (!updatedLabels.contains(labelId)) {
        updatedLabels.add(labelId);
        _chats[chatIndex] = chat.copyWith(labels: updatedLabels);
        notifyListeners();
      }
    }
  }

  void removeLabelFromChat(String chatId, String labelId) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final chat = _chats[chatIndex];
      final updatedLabels = List<String>.from(chat.labels);
      
      updatedLabels.remove(labelId);
      _chats[chatIndex] = chat.copyWith(labels: updatedLabels);
      notifyListeners();
    }
  }

  List<Chat> getChatsByLabel(String labelId) {
    return _chats.where((chat) => chat.labels.contains(labelId)).toList();
  }

  List<Chat> _getSampleChats() {
    final now = DateTime.now();
    return [
      Chat(
        id: '1',
        contactId: 'contact_1',
        contactName: 'John Smith',
        contactPhone: '+1234567890',
        lastMessage: 'Hi, I\'m interested in your products',
        lastMessageTime: now.subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        labels: ['new_customer'],
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(minutes: 5)),
      ),
      Chat(
        id: '2',
        contactId: 'contact_2',
        contactName: 'Sarah Johnson',
        contactPhone: '+1234567891',
        lastMessage: 'Thank you for the quick delivery!',
        lastMessageTime: now.subtract(const Duration(hours: 2)),
        unreadCount: 0,
        labels: ['order_complete'],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Chat(
        id: '3',
        contactId: 'contact_3',
        contactName: 'Mike Wilson',
        contactPhone: '+1234567892',
        lastMessage: 'When will my order be shipped?',
        lastMessageTime: now.subtract(const Duration(hours: 4)),
        unreadCount: 1,
        labels: ['pending_payment', 'to_be_shipped'],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),
    ];
  }

  List<Message> _getSampleMessages(String chatId) {
    final now = DateTime.now();
    
    switch (chatId) {
      case '1':
        return [
          Message(
            id: 'm1',
            chatId: chatId,
            senderId: 'contact_1',
            senderName: 'John Smith',
            content: 'Hi, I\'m interested in your products',
            type: MessageType.text,
            status: MessageStatus.read,
            timestamp: now.subtract(const Duration(minutes: 10)),
            isFromBusiness: false,
          ),
          Message(
            id: 'm2',
            chatId: chatId,
            senderId: 'business',
            content: 'Hello! Thank you for contacting us. How can we help you today?',
            type: MessageType.text,
            status: MessageStatus.delivered,
            timestamp: now.subtract(const Duration(minutes: 8)),
            isFromBusiness: true,
          ),
          Message(
            id: 'm3',
            chatId: chatId,
            senderId: 'contact_1',
            senderName: 'John Smith',
            content: 'Can you show me your catalog?',
            type: MessageType.text,
            status: MessageStatus.read,
            timestamp: now.subtract(const Duration(minutes: 5)),
            isFromBusiness: false,
          ),
        ];
      default:
        return [];
    }
  }
}