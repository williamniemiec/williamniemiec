import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/conversation.dart';
import '../services/openai_service.dart';

class ChatProvider extends ChangeNotifier {
  final OpenAIService _openAIService = OpenAIService();
  
  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  bool _isLoading = false;
  bool _isVoiceMode = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _selectedModel = 'gpt-3.5-turbo';

  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  bool get isVoiceMode => _isVoiceMode;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  String get selectedModel => _selectedModel;

  List<String> get availableModels => [
    'gpt-3.5-turbo',
    'gpt-4',
    'gpt-4-turbo',
    'gpt-4o',
  ];

  void setSelectedModel(String model) {
    _selectedModel = model;
    notifyListeners();
  }

  void createNewConversation() {
    final conversation = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _conversations.insert(0, conversation);
    _currentConversation = conversation;
    notifyListeners();
  }

  void selectConversation(String conversationId) {
    _currentConversation = _conversations.firstWhere(
      (conv) => conv.id == conversationId,
    );
    notifyListeners();
  }

  void deleteConversation(String conversationId) {
    _conversations.removeWhere((conv) => conv.id == conversationId);
    if (_currentConversation?.id == conversationId) {
      _currentConversation = _conversations.isNotEmpty ? _conversations.first : null;
    }
    notifyListeners();
  }

  Future<void> sendMessage(String content, {MessageType type = MessageType.text}) async {
    if (_currentConversation == null) {
      createNewConversation();
    }

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    _currentConversation!.messages.add(userMessage);
    _currentConversation!.updatedAt = DateTime.now();

    // Update conversation title if it's the first message
    if (_currentConversation!.messages.length == 1) {
      _currentConversation!.title = content.length > 50 
          ? '${content.substring(0, 50)}...' 
          : content;
    }

    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _openAIService.sendMessage(
        _currentConversation!.messages,
        model: _selectedModel,
      );

      final assistantMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        type: MessageType.text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      _currentConversation!.messages.add(assistantMessage);
      _currentConversation!.updatedAt = DateTime.now();
    } catch (e) {
      final errorMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I encountered an error: ${e.toString()}',
        type: MessageType.text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      _currentConversation!.messages.add(errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendImageMessage(String imagePath, String prompt) async {
    if (_currentConversation == null) {
      createNewConversation();
    }

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: prompt,
      type: MessageType.image,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );

    _currentConversation!.messages.add(userMessage);
    _currentConversation!.updatedAt = DateTime.now();
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _openAIService.analyzeImage(imagePath, prompt);

      final assistantMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        type: MessageType.text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      _currentConversation!.messages.add(assistantMessage);
      _currentConversation!.updatedAt = DateTime.now();
    } catch (e) {
      final errorMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I couldn\'t analyze the image: ${e.toString()}',
        type: MessageType.text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      _currentConversation!.messages.add(errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> generateImage(String prompt) async {
    if (_currentConversation == null) {
      createNewConversation();
    }

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: prompt,
      type: MessageType.text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    _currentConversation!.messages.add(userMessage);
    _currentConversation!.updatedAt = DateTime.now();
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final imageUrl = await _openAIService.generateImage(prompt);

      final assistantMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Generated image for: $prompt',
        type: MessageType.generatedImage,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        imagePath: imageUrl,
      );

      _currentConversation!.messages.add(assistantMessage);
      _currentConversation!.updatedAt = DateTime.now();
    } catch (e) {
      final errorMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I couldn\'t generate the image: ${e.toString()}',
        type: MessageType.text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      _currentConversation!.messages.add(errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleVoiceMode() {
    _isVoiceMode = !_isVoiceMode;
    notifyListeners();
  }

  void setListening(bool listening) {
    _isListening = listening;
    notifyListeners();
  }

  void setSpeaking(bool speaking) {
    _isSpeaking = speaking;
    notifyListeners();
  }

  void clearCurrentConversation() {
    if (_currentConversation != null) {
      _currentConversation!.messages.clear();
      _currentConversation!.title = 'New Chat';
      _currentConversation!.updatedAt = DateTime.now();
      notifyListeners();
    }
  }
}