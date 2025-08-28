import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionTier {
  free,
  plus,
}

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionTier _currentTier = SubscriptionTier.free;
  DateTime? _subscriptionExpiryDate;
  bool _isLoading = false;

  SubscriptionTier get currentTier => _currentTier;
  DateTime? get subscriptionExpiryDate => _subscriptionExpiryDate;
  bool get isLoading => _isLoading;
  bool get isPlusSubscriber => _currentTier == SubscriptionTier.plus;
  bool get hasFreeAccess => _currentTier == SubscriptionTier.free;

  // Plus features
  bool get hasAdvancedModels => isPlusSubscriber;
  bool get hasFasterResponses => isPlusSubscriber;
  bool get hasPriorityAccess => isPlusSubscriber;
  bool get hasUnlimitedMessages => isPlusSubscriber;
  bool get hasImageGeneration => isPlusSubscriber;
  bool get hasVoiceMode => true; // Available for all users
  bool get hasImageAnalysis => true; // Available for all users

  // Usage limits for free tier
  int _dailyMessageCount = 0;
  int _dailyImageGenerations = 0;
  DateTime _lastResetDate = DateTime.now();

  int get dailyMessageCount => _dailyMessageCount;
  int get dailyImageGenerations => _dailyImageGenerations;
  int get remainingMessages => isPlusSubscriber ? -1 : (50 - _dailyMessageCount).clamp(0, 50);
  int get remainingImageGenerations => isPlusSubscriber ? -1 : (3 - _dailyImageGenerations).clamp(0, 3);

  SubscriptionProvider() {
    _loadSubscriptionState();
  }

  Future<void> _loadSubscriptionState() async {
    final prefs = await SharedPreferences.getInstance();
    
    final tierString = prefs.getString('subscription_tier');
    if (tierString != null) {
      _currentTier = SubscriptionTier.values.firstWhere(
        (tier) => tier.toString() == tierString,
        orElse: () => SubscriptionTier.free,
      );
    }

    final expiryString = prefs.getString('subscription_expiry');
    if (expiryString != null) {
      _subscriptionExpiryDate = DateTime.parse(expiryString);
      
      // Check if subscription has expired
      if (_subscriptionExpiryDate!.isBefore(DateTime.now())) {
        _currentTier = SubscriptionTier.free;
        _subscriptionExpiryDate = null;
        await _saveSubscriptionState();
      }
    }

    _dailyMessageCount = prefs.getInt('daily_message_count') ?? 0;
    _dailyImageGenerations = prefs.getInt('daily_image_generations') ?? 0;
    
    final lastResetString = prefs.getString('last_reset_date');
    if (lastResetString != null) {
      _lastResetDate = DateTime.parse(lastResetString);
      
      // Reset daily counters if it's a new day
      if (!_isSameDay(_lastResetDate, DateTime.now())) {
        await _resetDailyCounters();
      }
    }

    notifyListeners();
  }

  Future<void> _saveSubscriptionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscription_tier', _currentTier.toString());
    
    if (_subscriptionExpiryDate != null) {
      await prefs.setString('subscription_expiry', _subscriptionExpiryDate!.toIso8601String());
    } else {
      await prefs.remove('subscription_expiry');
    }
  }

  Future<void> _resetDailyCounters() async {
    _dailyMessageCount = 0;
    _dailyImageGenerations = 0;
    _lastResetDate = DateTime.now();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_message_count', 0);
    await prefs.setInt('daily_image_generations', 0);
    await prefs.setString('last_reset_date', _lastResetDate.toIso8601String());
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<bool> subscribeToPlusMonthly() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate subscription process
      await Future.delayed(const Duration(seconds: 2));
      
      _currentTier = SubscriptionTier.plus;
      _subscriptionExpiryDate = DateTime.now().add(const Duration(days: 30));
      
      await _saveSubscriptionState();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> subscribeToPlusYearly() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate subscription process
      await Future.delayed(const Duration(seconds: 2));
      
      _currentTier = SubscriptionTier.plus;
      _subscriptionExpiryDate = DateTime.now().add(const Duration(days: 365));
      
      await _saveSubscriptionState();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> cancelSubscription() async {
    _currentTier = SubscriptionTier.free;
    _subscriptionExpiryDate = null;
    
    await _saveSubscriptionState();
    notifyListeners();
  }

  bool canSendMessage() {
    if (isPlusSubscriber) return true;
    return _dailyMessageCount < 50;
  }

  bool canGenerateImage() {
    if (isPlusSubscriber) return true;
    return _dailyImageGenerations < 3;
  }

  Future<void> incrementMessageCount() async {
    if (isPlusSubscriber) return;
    
    _dailyMessageCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_message_count', _dailyMessageCount);
    notifyListeners();
  }

  Future<void> incrementImageGenerationCount() async {
    if (isPlusSubscriber) return;
    
    _dailyImageGenerations++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_image_generations', _dailyImageGenerations);
    notifyListeners();
  }

  String get subscriptionStatusText {
    if (isPlusSubscriber) {
      if (_subscriptionExpiryDate != null) {
        final daysRemaining = _subscriptionExpiryDate!.difference(DateTime.now()).inDays;
        return 'ChatGPT Plus • $daysRemaining days remaining';
      }
      return 'ChatGPT Plus';
    }
    return 'Free Plan';
  }

  List<String> get plusFeatures => [
    'Access to GPT-4 and GPT-4 Turbo',
    'Faster response times',
    'Priority access during peak times',
    'Unlimited messages',
    'Unlimited image generations',
    'Early access to new features',
  ];

  double get monthlyPrice => 20.0;
  double get yearlyPrice => 200.0;
  double get yearlySavings => (monthlyPrice * 12) - yearlyPrice;
}