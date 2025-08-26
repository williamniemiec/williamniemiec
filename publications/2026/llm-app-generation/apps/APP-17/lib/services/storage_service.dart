import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../models/subscription.dart';
import '../models/chat_message.dart';
import '../models/dating_profile.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // User Management
  Future<void> saveUser(User user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(AppConstants.userKey, userJson);
      debugPrint('User saved successfully');
    } catch (e) {
      debugPrint('Error saving user: $e');
      throw StorageException('Failed to save user data');
    }
  }

  Future<User?> getUser() async {
    try {
      final userJson = prefs.getString(AppConstants.userKey);
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      debugPrint('Error loading user: $e');
      return null;
    }
  }

  Future<void> deleteUser() async {
    try {
      await prefs.remove(AppConstants.userKey);
      debugPrint('User data deleted');
    } catch (e) {
      debugPrint('Error deleting user: $e');
      throw StorageException('Failed to delete user data');
    }
  }

  // Subscription Management
  Future<void> saveSubscription(Subscription subscription) async {
    try {
      final subscriptionJson = jsonEncode(subscription.toJson());
      await prefs.setString(AppConstants.subscriptionKey, subscriptionJson);
      debugPrint('Subscription saved successfully');
    } catch (e) {
      debugPrint('Error saving subscription: $e');
      throw StorageException('Failed to save subscription data');
    }
  }

  Future<Subscription?> getSubscription() async {
    try {
      final subscriptionJson = prefs.getString(AppConstants.subscriptionKey);
      if (subscriptionJson == null) return null;
      
      final subscriptionMap = jsonDecode(subscriptionJson) as Map<String, dynamic>;
      return Subscription.fromJson(subscriptionMap);
    } catch (e) {
      debugPrint('Error loading subscription: $e');
      return null;
    }
  }

  // Chat History Management
  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final messagesJson = messages.map((m) => m.toJson()).toList();
      final historyJson = jsonEncode(messagesJson);
      await prefs.setString(AppConstants.chatHistoryKey, historyJson);
      debugPrint('Chat history saved: ${messages.length} messages');
    } catch (e) {
      debugPrint('Error saving chat history: $e');
      throw StorageException('Failed to save chat history');
    }
  }

  Future<List<ChatMessage>> getChatHistory() async {
    try {
      final historyJson = prefs.getString(AppConstants.chatHistoryKey);
      if (historyJson == null) return [];
      
      final messagesList = jsonDecode(historyJson) as List<dynamic>;
      return messagesList
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading chat history: $e');
      return [];
    }
  }

  Future<void> addChatMessage(ChatMessage message) async {
    try {
      final currentHistory = await getChatHistory();
      currentHistory.add(message);
      
      // Keep only the last 100 messages to prevent storage bloat
      if (currentHistory.length > 100) {
        currentHistory.removeRange(0, currentHistory.length - 100);
      }
      
      await saveChatHistory(currentHistory);
    } catch (e) {
      debugPrint('Error adding chat message: $e');
      throw StorageException('Failed to add chat message');
    }
  }

  Future<void> clearChatHistory() async {
    try {
      await prefs.remove(AppConstants.chatHistoryKey);
      debugPrint('Chat history cleared');
    } catch (e) {
      debugPrint('Error clearing chat history: $e');
      throw StorageException('Failed to clear chat history');
    }
  }

  // Dating Profiles Management
  Future<void> saveDatingProfiles(List<DatingProfile> profiles) async {
    try {
      final profilesJson = profiles.map((p) => p.toJson()).toList();
      final dataJson = jsonEncode(profilesJson);
      await prefs.setString(AppConstants.profilesKey, dataJson);
      debugPrint('Dating profiles saved: ${profiles.length} profiles');
    } catch (e) {
      debugPrint('Error saving dating profiles: $e');
      throw StorageException('Failed to save dating profiles');
    }
  }

  Future<List<DatingProfile>> getDatingProfiles() async {
    try {
      final profilesJson = prefs.getString(AppConstants.profilesKey);
      if (profilesJson == null) return [];
      
      final profilesList = jsonDecode(profilesJson) as List<dynamic>;
      return profilesList
          .map((p) => DatingProfile.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading dating profiles: $e');
      return [];
    }
  }

  Future<void> addDatingProfile(DatingProfile profile) async {
    try {
      final currentProfiles = await getDatingProfiles();
      
      // Remove existing profile with same ID if it exists
      currentProfiles.removeWhere((p) => p.id == profile.id);
      currentProfiles.add(profile);
      
      // Keep only the last 10 profiles
      if (currentProfiles.length > 10) {
        currentProfiles.removeRange(0, currentProfiles.length - 10);
      }
      
      await saveDatingProfiles(currentProfiles);
    } catch (e) {
      debugPrint('Error adding dating profile: $e');
      throw StorageException('Failed to add dating profile');
    }
  }

  Future<void> deleteDatingProfile(String profileId) async {
    try {
      final currentProfiles = await getDatingProfiles();
      currentProfiles.removeWhere((p) => p.id == profileId);
      await saveDatingProfiles(currentProfiles);
      debugPrint('Dating profile deleted: $profileId');
    } catch (e) {
      debugPrint('Error deleting dating profile: $e');
      throw StorageException('Failed to delete dating profile');
    }
  }

  // App Settings
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      } else {
        // For complex objects, store as JSON string
        await prefs.setString(key, jsonEncode(value));
      }
      debugPrint('Setting saved: $key');
    } catch (e) {
      debugPrint('Error saving setting $key: $e');
      throw StorageException('Failed to save setting: $key');
    }
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      if (T == String) {
        return prefs.getString(key) as T? ?? defaultValue;
      } else if (T == int) {
        return prefs.getInt(key) as T? ?? defaultValue;
      } else if (T == double) {
        return prefs.getDouble(key) as T? ?? defaultValue;
      } else if (T == bool) {
        return prefs.getBool(key) as T? ?? defaultValue;
      } else if (T == List<String>) {
        return prefs.getStringList(key) as T? ?? defaultValue;
      } else {
        // For complex objects, try to decode from JSON
        final jsonString = prefs.getString(key);
        if (jsonString == null) return defaultValue;
        return jsonDecode(jsonString) as T? ?? defaultValue;
      }
    } catch (e) {
      debugPrint('Error getting setting $key: $e');
      return defaultValue;
    }
  }

  Future<void> deleteSetting(String key) async {
    try {
      await prefs.remove(key);
      debugPrint('Setting deleted: $key');
    } catch (e) {
      debugPrint('Error deleting setting $key: $e');
      throw StorageException('Failed to delete setting: $key');
    }
  }

  // Usage Tracking
  Future<void> incrementUsageCount(String featureType) async {
    try {
      final key = 'usage_$featureType';
      final currentCount = getSetting<int>(key, defaultValue: 0) ?? 0;
      await saveSetting(key, currentCount + 1);
      debugPrint('Usage incremented for $featureType: ${currentCount + 1}');
    } catch (e) {
      debugPrint('Error incrementing usage for $featureType: $e');
    }
  }

  int getUsageCount(String featureType) {
    final key = 'usage_$featureType';
    return getSetting<int>(key, defaultValue: 0) ?? 0;
  }

  Future<void> resetDailyUsage() async {
    try {
      final features = ['chatAnalysis', 'profileRoast', 'bioGenerator', 'rizzGenerator'];
      for (final feature in features) {
        await saveSetting('daily_usage_$feature', 0);
      }
      await saveSetting('last_usage_reset', DateTime.now().toIso8601String());
      debugPrint('Daily usage reset');
    } catch (e) {
      debugPrint('Error resetting daily usage: $e');
    }
  }

  int getDailyUsageCount(String featureType) {
    return getSetting<int>('daily_usage_$featureType', defaultValue: 0) ?? 0;
  }

  Future<void> incrementDailyUsage(String featureType) async {
    try {
      final key = 'daily_usage_$featureType';
      final currentCount = getDailyUsageCount(featureType);
      await saveSetting(key, currentCount + 1);
      debugPrint('Daily usage incremented for $featureType: ${currentCount + 1}');
    } catch (e) {
      debugPrint('Error incrementing daily usage for $featureType: $e');
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await prefs.clear();
      debugPrint('All storage data cleared');
    } catch (e) {
      debugPrint('Error clearing all data: $e');
      throw StorageException('Failed to clear all data');
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}