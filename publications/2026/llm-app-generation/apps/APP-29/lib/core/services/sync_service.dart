import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversation.dart';
import '../constants/app_constants.dart';

class SyncService {
  static const String _syncTimestampKey = 'last_sync_timestamp';
  static const String _deviceIdKey = 'device_id';
  
  // Simulate cloud storage with local storage for demo
  Future<void> syncConversations(List<Conversation> conversations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = await _getDeviceId();
      
      // Simulate uploading to cloud
      final conversationsJson = conversations.map((c) => c.toJson()).toList();
      await prefs.setString('${AppConstants.conversationsKey}_$deviceId', jsonEncode(conversationsJson));
      await prefs.setString(_syncTimestampKey, DateTime.now().toIso8601String());
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('Conversations synced successfully');
    } catch (e) {
      print('Sync failed: $e');
      throw Exception('Failed to sync conversations');
    }
  }
  
  Future<List<Conversation>> downloadConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = await _getDeviceId();
      
      // Simulate downloading from cloud
      await Future.delayed(const Duration(milliseconds: 300));
      
      final conversationsString = prefs.getString('${AppConstants.conversationsKey}_$deviceId');
      if (conversationsString == null) {
        return [];
      }
      
      final conversationsJson = jsonDecode(conversationsString) as List;
      return conversationsJson.map((json) => Conversation.fromJson(json)).toList();
    } catch (e) {
      print('Download failed: $e');
      throw Exception('Failed to download conversations');
    }
  }
  
  Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampString = prefs.getString(_syncTimestampKey);
      
      if (timestampString == null) return null;
      return DateTime.parse(timestampString);
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> needsSync(List<Conversation> localConversations) async {
    final lastSync = await getLastSyncTime();
    
    // If never synced, sync is needed
    if (lastSync == null) return localConversations.isNotEmpty;
    
    // Check if any conversation was updated after last sync
    for (final conversation in localConversations) {
      if (conversation.updatedAt.isAfter(lastSync)) {
        return true;
      }
    }
    
    return false;
  }
  
  Future<SyncStatus> getSyncStatus(List<Conversation> localConversations) async {
    final lastSync = await getLastSyncTime();
    final needsSync = await this.needsSync(localConversations);
    
    if (lastSync == null) {
      return SyncStatus.neverSynced;
    } else if (needsSync) {
      return SyncStatus.needsSync;
    } else {
      return SyncStatus.synced;
    }
  }
  
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_deviceIdKey, deviceId);
    }
    
    return deviceId;
  }
  
  Future<void> clearSyncData() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = await _getDeviceId();
    
    await prefs.remove('${AppConstants.conversationsKey}_$deviceId');
    await prefs.remove(_syncTimestampKey);
  }
  
  // Simulate merging conversations from multiple devices
  List<Conversation> mergeConversations(
    List<Conversation> localConversations,
    List<Conversation> remoteConversations,
  ) {
    final Map<String, Conversation> mergedMap = {};
    
    // Add local conversations
    for (final conversation in localConversations) {
      mergedMap[conversation.id] = conversation;
    }
    
    // Merge remote conversations (keep the most recent version)
    for (final remoteConversation in remoteConversations) {
      final existingConversation = mergedMap[remoteConversation.id];
      
      if (existingConversation == null) {
        // New conversation from remote
        mergedMap[remoteConversation.id] = remoteConversation;
      } else {
        // Keep the most recently updated version
        if (remoteConversation.updatedAt.isAfter(existingConversation.updatedAt)) {
          mergedMap[remoteConversation.id] = remoteConversation;
        }
      }
    }
    
    // Sort by updated time (most recent first)
    final mergedList = mergedMap.values.toList();
    mergedList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    return mergedList;
  }
  
  // Auto-sync functionality
  Future<void> performAutoSync(List<Conversation> conversations) async {
    try {
      if (await needsSync(conversations)) {
        await syncConversations(conversations);
      }
    } catch (e) {
      // Silent fail for auto-sync
      print('Auto-sync failed: $e');
    }
  }
}

enum SyncStatus {
  neverSynced,
  synced,
  needsSync,
  syncing,
  error,
}

extension SyncStatusExtension on SyncStatus {
  String get displayText {
    switch (this) {
      case SyncStatus.neverSynced:
        return 'Not synced';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.needsSync:
        return 'Needs sync';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.error:
        return 'Sync error';
    }
  }
  
  IconData get icon {
    switch (this) {
      case SyncStatus.neverSynced:
        return Icons.cloud_off;
      case SyncStatus.synced:
        return Icons.cloud_done;
      case SyncStatus.needsSync:
        return Icons.cloud_upload;
      case SyncStatus.syncing:
        return Icons.cloud_sync;
      case SyncStatus.error:
        return Icons.error_outline;
    }
  }
}