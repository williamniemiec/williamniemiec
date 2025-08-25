import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/audiobook.dart';
import '../models/podcast.dart';

enum DownloadStatus {
  notDownloaded,
  downloading,
  downloaded,
  paused,
  failed,
}

class DownloadItem {
  final String id;
  final String title;
  final String type; // 'audiobook' or 'podcast'
  final DownloadStatus status;
  final double progress;
  final DateTime? downloadedAt;
  final String? filePath;
  final int? fileSize;

  DownloadItem({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.progress = 0.0,
    this.downloadedAt,
    this.filePath,
    this.fileSize,
  });

  DownloadItem copyWith({
    String? id,
    String? title,
    String? type,
    DownloadStatus? status,
    double? progress,
    DateTime? downloadedAt,
    String? filePath,
    int? fileSize,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}

class DownloadService extends StateNotifier<Map<String, DownloadItem>> {
  late Box<Map> _downloadBox;
  
  DownloadService() : super({}) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _downloadBox = await Hive.openBox<Map>('downloads');
      _loadDownloads();
    } catch (e) {
      print('Error initializing download service: $e');
    }
  }

  void _loadDownloads() {
    final downloads = <String, DownloadItem>{};
    
    for (final key in _downloadBox.keys) {
      final data = _downloadBox.get(key);
      if (data != null) {
        downloads[key] = DownloadItem(
          id: data['id'] ?? key,
          title: data['title'] ?? 'Unknown',
          type: data['type'] ?? 'audiobook',
          status: DownloadStatus.values[data['status'] ?? 0],
          progress: (data['progress'] ?? 0.0).toDouble(),
          downloadedAt: data['downloadedAt'] != null 
              ? DateTime.fromMillisecondsSinceEpoch(data['downloadedAt'])
              : null,
          filePath: data['filePath'],
          fileSize: data['fileSize'],
        );
      }
    }
    
    state = downloads;
  }

  Future<void> _saveDownload(DownloadItem item) async {
    await _downloadBox.put(item.id, {
      'id': item.id,
      'title': item.title,
      'type': item.type,
      'status': item.status.index,
      'progress': item.progress,
      'downloadedAt': item.downloadedAt?.millisecondsSinceEpoch,
      'filePath': item.filePath,
      'fileSize': item.fileSize,
    });
  }

  Future<void> startDownload(String id, String title, String type) async {
    final item = DownloadItem(
      id: id,
      title: title,
      type: type,
      status: DownloadStatus.downloading,
      progress: 0.0,
    );
    
    state = {...state, id: item};
    await _saveDownload(item);
    
    // Simulate download progress
    _simulateDownload(id);
  }

  Future<void> _simulateDownload(String id) async {
    const totalSteps = 100;
    const stepDuration = Duration(milliseconds: 50);
    
    for (int i = 1; i <= totalSteps; i++) {
      await Future.delayed(stepDuration);
      
      final currentItem = state[id];
      if (currentItem == null || currentItem.status != DownloadStatus.downloading) {
        break;
      }
      
      final progress = i / totalSteps;
      final updatedItem = currentItem.copyWith(
        progress: progress,
        status: i == totalSteps ? DownloadStatus.downloaded : DownloadStatus.downloading,
        downloadedAt: i == totalSteps ? DateTime.now() : null,
        filePath: i == totalSteps ? '/storage/downloads/$id.mp3' : null,
        fileSize: i == totalSteps ? 50 * 1024 * 1024 : null, // 50MB
      );
      
      state = {...state, id: updatedItem};
      await _saveDownload(updatedItem);
    }
  }

  Future<void> pauseDownload(String id) async {
    final item = state[id];
    if (item != null && item.status == DownloadStatus.downloading) {
      final updatedItem = item.copyWith(status: DownloadStatus.paused);
      state = {...state, id: updatedItem};
      await _saveDownload(updatedItem);
    }
  }

  Future<void> resumeDownload(String id) async {
    final item = state[id];
    if (item != null && item.status == DownloadStatus.paused) {
      final updatedItem = item.copyWith(status: DownloadStatus.downloading);
      state = {...state, id: updatedItem};
      await _saveDownload(updatedItem);
      _simulateDownload(id);
    }
  }

  Future<void> cancelDownload(String id) async {
    final item = state[id];
    if (item != null) {
      final newState = Map<String, DownloadItem>.from(state);
      newState.remove(id);
      state = newState;
      await _downloadBox.delete(id);
    }
  }

  Future<void> deleteDownload(String id) async {
    await cancelDownload(id);
  }

  bool isDownloaded(String id) {
    final item = state[id];
    return item?.status == DownloadStatus.downloaded;
  }

  bool isDownloading(String id) {
    final item = state[id];
    return item?.status == DownloadStatus.downloading;
  }

  double getDownloadProgress(String id) {
    final item = state[id];
    return item?.progress ?? 0.0;
  }

  List<DownloadItem> getDownloadedItems() {
    return state.values
        .where((item) => item.status == DownloadStatus.downloaded)
        .toList()
      ..sort((a, b) => (b.downloadedAt ?? DateTime(0))
          .compareTo(a.downloadedAt ?? DateTime(0)));
  }

  List<DownloadItem> getActiveDownloads() {
    return state.values
        .where((item) => 
            item.status == DownloadStatus.downloading ||
            item.status == DownloadStatus.paused)
        .toList();
  }

  int getTotalDownloadedSize() {
    return state.values
        .where((item) => item.status == DownloadStatus.downloaded)
        .fold(0, (sum, item) => sum + (item.fileSize ?? 0));
  }

  int getDownloadedCount() {
    return state.values
        .where((item) => item.status == DownloadStatus.downloaded)
        .length;
  }
}

// Providers
final downloadServiceProvider = StateNotifierProvider<DownloadService, Map<String, DownloadItem>>((ref) {
  return DownloadService();
});

final downloadedItemsProvider = Provider<List<DownloadItem>>((ref) {
  final downloadService = ref.watch(downloadServiceProvider.notifier);
  return downloadService.getDownloadedItems();
});

final activeDownloadsProvider = Provider<List<DownloadItem>>((ref) {
  final downloadService = ref.watch(downloadServiceProvider.notifier);
  return downloadService.getActiveDownloads();
});

final downloadStatsProvider = Provider<Map<String, int>>((ref) {
  final downloadService = ref.watch(downloadServiceProvider.notifier);
  return {
    'count': downloadService.getDownloadedCount(),
    'size': downloadService.getTotalDownloadedSize(),
  };
});

// Helper functions for UI
String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

String getDownloadStatusText(DownloadStatus status) {
  switch (status) {
    case DownloadStatus.notDownloaded:
      return 'Not Downloaded';
    case DownloadStatus.downloading:
      return 'Downloading...';
    case DownloadStatus.downloaded:
      return 'Downloaded';
    case DownloadStatus.paused:
      return 'Paused';
    case DownloadStatus.failed:
      return 'Failed';
  }
}

IconData getDownloadStatusIcon(DownloadStatus status) {
  switch (status) {
    case DownloadStatus.notDownloaded:
      return Icons.download_outlined;
    case DownloadStatus.downloading:
      return Icons.downloading;
    case DownloadStatus.downloaded:
      return Icons.download_done;
    case DownloadStatus.paused:
      return Icons.pause_circle_outline;
    case DownloadStatus.failed:
      return Icons.error_outline;
  }
}