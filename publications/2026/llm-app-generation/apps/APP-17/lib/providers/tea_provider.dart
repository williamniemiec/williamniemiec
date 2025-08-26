import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/subscription.dart';
import '../models/chat_message.dart';
import '../models/dating_profile.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../services/subscription_service.dart';
import '../services/image_service.dart';

class TeaProvider extends ChangeNotifier {
  // Services
  final AIService _aiService = AIService();
  final StorageService _storageService = StorageService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  final ImageService _imageService = ImageService();

  // State
  User? _currentUser;
  Subscription? _currentSubscription;
  List<ChatMessage> _chatHistory = [];
  List<DatingProfile> _datingProfiles = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  Subscription? get currentSubscription => _currentSubscription;
  List<ChatMessage> get chatHistory => _chatHistory;
  List<DatingProfile> get datingProfiles => _datingProfiles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPremium => _subscriptionService.isPremium;

  // Initialization
  Future<void> initialize() async {
    try {
      _setLoading(true);
      
      // Initialize storage service
      await _storageService.init();
      
      // Initialize subscription service
      await _subscriptionService.initialize();
      
      // Load user data
      await _loadUserData();
      
      // Load chat history
      await _loadChatHistory();
      
      // Load dating profiles
      await _loadDatingProfiles();
      
      _clearError();
    } catch (e) {
      _setError('Failed to initialize app: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadUserData() async {
    try {
      _currentUser = await _storageService.getUser();
      _currentSubscription = await _storageService.getSubscription();
      
      // Create default user if none exists
      if (_currentUser == null) {
        _currentUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
        );
        await _storageService.saveUser(_currentUser!);
      }
      
      // Check if daily usage needs reset
      if (_currentUser!.needsUsageReset) {
        await _storageService.resetDailyUsage();
        _currentUser = _currentUser!.copyWith(
          lastUsageReset: DateTime.now(),
          dailyUsageCount: 0,
        );
        await _storageService.saveUser(_currentUser!);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      _chatHistory = await _storageService.getChatHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
  }

  Future<void> _loadDatingProfiles() async {
    try {
      _datingProfiles = await _storageService.getDatingProfiles();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading dating profiles: $e');
    }
  }

  // Chat functionality
  Future<void> sendMessage(String content, {
    FeatureType? featureType,
    List<String>? imageUrls,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _clearError();
      
      // Create user message
      final userMessage = ChatMessage.createUserMessage(
        content: content,
        featureType: featureType,
        imageUrls: imageUrls,
        metadata: metadata,
      );
      
      // Add user message to chat
      _chatHistory.add(userMessage);
      await _storageService.addChatMessage(userMessage);
      notifyListeners();
      
      // Add loading message
      final loadingMessage = ChatMessage.createLoadingMessage();
      _chatHistory.add(loadingMessage);
      notifyListeners();
      
      // Get AI response based on feature type
      String aiResponse;
      switch (featureType) {
        case FeatureType.chatAnalysis:
          if (!_canUseFeature('chatAnalysis')) {
            throw Exception('Daily limit reached for chat analysis');
          }
          aiResponse = await _aiService.analyzeConversation(
            imageUrls: imageUrls ?? [],
            additionalContext: content,
          );
          await _recordFeatureUsage('chatAnalysis');
          break;
          
        case FeatureType.profileRoast:
          if (!_canUseFeature('profileRoast')) {
            throw Exception('Daily limit reached for profile roast');
          }
          final profileData = metadata ?? {};
          aiResponse = await _aiService.roastProfile(
            bio: profileData['bio'] ?? '',
            photoUrls: imageUrls ?? [],
            age: profileData['age'],
            location: profileData['location'],
            interests: profileData['interests'],
          );
          await _recordFeatureUsage('profileRoast');
          break;
          
        case FeatureType.bioGenerator:
          if (!_canUseFeature('bioGenerator')) {
            throw Exception('Daily limit reached for bio generation');
          }
          final bioData = metadata ?? {};
          final bios = await _aiService.generateBios(
            interests: bioData['interests'] ?? [],
            personality: bioData['personality'] ?? '',
            age: bioData['age'],
            occupation: bioData['occupation'],
          );
          aiResponse = bios.join('\n\n---\n\n');
          await _recordFeatureUsage('bioGenerator');
          break;
          
        case FeatureType.rizzGenerator:
          if (!_canUseFeature('rizzGenerator')) {
            throw Exception('Daily limit reached for rizz generation');
          }
          final rizzLines = await _aiService.generateRizzLines(
            context: content,
            profileInfo: metadata?['profileInfo'],
            conversationTopic: metadata?['conversationTopic'],
          );
          aiResponse = rizzLines.join('\n\n');
          await _recordFeatureUsage('rizzGenerator');
          break;
          
        case FeatureType.generalAdvice:
        default:
          aiResponse = await _aiService.getGeneralAdvice(
            question: content,
            context: metadata?['context'],
          );
          break;
      }
      
      // Remove loading message and add AI response
      _chatHistory.removeLast();
      final assistantMessage = ChatMessage.createAssistantMessage(
        content: aiResponse,
        featureType: featureType,
        metadata: metadata,
      );
      
      _chatHistory.add(assistantMessage);
      await _storageService.addChatMessage(assistantMessage);
      notifyListeners();
      
    } catch (e) {
      // Remove loading message if it exists
      if (_chatHistory.isNotEmpty && _chatHistory.last.isLoading) {
        _chatHistory.removeLast();
      }
      
      _setError(e.toString());
      notifyListeners();
    }
  }

  Future<void> clearChatHistory() async {
    try {
      _chatHistory.clear();
      await _storageService.clearChatHistory();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear chat history: ${e.toString()}');
    }
  }

  // Dating profile management
  Future<void> saveDatingProfile(DatingProfile profile) async {
    try {
      await _storageService.addDatingProfile(profile);
      await _loadDatingProfiles();
    } catch (e) {
      _setError('Failed to save dating profile: ${e.toString()}');
    }
  }

  Future<void> deleteDatingProfile(String profileId) async {
    try {
      await _storageService.deleteDatingProfile(profileId);
      await _loadDatingProfiles();
    } catch (e) {
      _setError('Failed to delete dating profile: ${e.toString()}');
    }
  }

  // Image handling
  Future<List<String>> pickImages({bool allowMultiple = true}) async {
    try {
      if (allowMultiple) {
        return await _imageService.pickImagesFromGallery();
      } else {
        final image = await _imageService.pickSingleImageFromGallery();
        return image != null ? [image] : [];
      }
    } catch (e) {
      _setError('Failed to pick images: ${e.toString()}');
      return [];
    }
  }

  Future<String?> takePhoto() async {
    try {
      return await _imageService.takePhotoWithCamera();
    } catch (e) {
      _setError('Failed to take photo: ${e.toString()}');
      return null;
    }
  }

  // Subscription management
  Future<void> purchaseSubscription(String productId) async {
    try {
      _setLoading(true);
      await _subscriptionService.purchaseSubscription(productId);
      _currentSubscription = _subscriptionService.currentSubscription;
      notifyListeners();
    } catch (e) {
      _setError('Failed to purchase subscription: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  bool _canUseFeature(String featureType) {
    return _subscriptionService.canUseFeature(featureType);
  }

  int getRemainingUsage(String featureType) {
    return _subscriptionService.getRemainingUsage(featureType);
  }

  Future<void> _recordFeatureUsage(String featureType) async {
    await _subscriptionService.recordFeatureUsage(featureType);
    
    // Update user's daily usage count
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        dailyUsageCount: _currentUser!.dailyUsageCount + 1,
      );
      await _storageService.saveUser(_currentUser!);
    }
  }

  // User management
  Future<void> updateUser(User user) async {
    try {
      _currentUser = user;
      await _storageService.saveUser(user);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update user: ${e.toString()}');
    }
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _subscriptionService.dispose();
    super.dispose();
  }
}