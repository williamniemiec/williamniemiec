import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/playback_state.dart';
import '../models/audiobook.dart';
import '../models/podcast.dart';

class AudioPlayerService extends StateNotifier<PlaybackState> {
  late Box<Map> _playbackBox;
  
  AudioPlayerService() : super(const PlaybackState()) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _playbackBox = await Hive.openBox<Map>('playback');
      _loadPlaybackState();
    } catch (e) {
      print('Error initializing audio service: $e');
    }
  }

  void _loadPlaybackState() {
    final data = _playbackBox.get('current_state');
    if (data != null) {
      state = PlaybackState(
        currentItemId: data['currentItemId'],
        currentContentType: data['currentContentType'] != null 
            ? ContentType.values[data['currentContentType']]
            : null,
        currentPosition: Duration(milliseconds: data['currentPosition'] ?? 0),
        totalDuration: Duration(milliseconds: data['totalDuration'] ?? 0),
        isPlaying: data['isPlaying'] ?? false,
        isLoading: false, // Never restore loading state
        playbackSpeed: (data['playbackSpeed'] ?? 1.0).toDouble(),
        repeatMode: RepeatMode.values[data['repeatMode'] ?? 0],
        shuffleEnabled: data['shuffleEnabled'] ?? false,
        queue: List<String>.from(data['queue'] ?? []),
        currentQueueIndex: data['currentQueueIndex'] ?? 0,
        currentChapterId: data['currentChapterId'],
      );
    }
  }

  Future<void> _savePlaybackState() async {
    await _playbackBox.put('current_state', {
      'currentItemId': state.currentItemId,
      'currentContentType': state.currentContentType?.index,
      'currentPosition': state.currentPosition.inMilliseconds,
      'totalDuration': state.totalDuration.inMilliseconds,
      'isPlaying': state.isPlaying,
      'playbackSpeed': state.playbackSpeed,
      'repeatMode': state.repeatMode.index,
      'shuffleEnabled': state.shuffleEnabled,
      'queue': state.queue,
      'currentQueueIndex': state.currentQueueIndex,
      'currentChapterId': state.currentChapterId,
    });
  }

  Future<void> playAudiobook(Audiobook audiobook, {Chapter? startChapter}) async {
    state = state.copyWith(
      currentItemId: audiobook.id,
      currentContentType: ContentType.audiobook,
      totalDuration: audiobook.duration,
      currentPosition: Duration.zero,
      isLoading: true,
      queue: [audiobook.id],
      currentQueueIndex: 0,
      currentChapterId: startChapter?.id ?? audiobook.chapters.first.id,
    );

    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    state = state.copyWith(
      isLoading: false,
      isPlaying: true,
    );
    
    await _savePlaybackState();
    _startProgressSimulation();
  }

  Future<void> playPodcastEpisode(Podcast podcast, PodcastEpisode episode) async {
    state = state.copyWith(
      currentItemId: episode.id,
      currentContentType: ContentType.podcast,
      totalDuration: episode.duration,
      currentPosition: Duration.zero,
      isLoading: true,
      queue: [episode.id],
      currentQueueIndex: 0,
    );

    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    state = state.copyWith(
      isLoading: false,
      isPlaying: true,
    );
    
    await _savePlaybackState();
    _startProgressSimulation();
  }

  Future<void> play() async {
    if (state.hasCurrentItem) {
      state = state.copyWith(isPlaying: true);
      await _savePlaybackState();
      _startProgressSimulation();
    }
  }

  Future<void> pause() async {
    state = state.copyWith(isPlaying: false);
    await _savePlaybackState();
  }

  Future<void> stop() async {
    state = const PlaybackState();
    await _playbackBox.delete('current_state');
  }

  Future<void> seekTo(Duration position) async {
    if (position <= state.totalDuration) {
      state = state.copyWith(currentPosition: position);
      await _savePlaybackState();
    }
  }

  Future<void> skipForward({Duration duration = const Duration(seconds: 30)}) async {
    final newPosition = state.currentPosition + duration;
    await seekTo(newPosition > state.totalDuration ? state.totalDuration : newPosition);
  }

  Future<void> skipBackward({Duration duration = const Duration(seconds: 30)}) async {
    final newPosition = state.currentPosition - duration;
    await seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    state = state.copyWith(playbackSpeed: speed);
    await _savePlaybackState();
  }

  Future<void> setRepeatMode(RepeatMode mode) async {
    state = state.copyWith(repeatMode: mode);
    await _savePlaybackState();
  }

  Future<void> toggleShuffle() async {
    state = state.copyWith(shuffleEnabled: !state.shuffleEnabled);
    await _savePlaybackState();
  }

  Future<void> nextTrack() async {
    if (state.currentQueueIndex < state.queue.length - 1) {
      final nextIndex = state.currentQueueIndex + 1;
      state = state.copyWith(
        currentQueueIndex: nextIndex,
        currentItemId: state.queue[nextIndex],
        currentPosition: Duration.zero,
      );
      await _savePlaybackState();
    }
  }

  Future<void> previousTrack() async {
    if (state.currentQueueIndex > 0) {
      final prevIndex = state.currentQueueIndex - 1;
      state = state.copyWith(
        currentQueueIndex: prevIndex,
        currentItemId: state.queue[prevIndex],
        currentPosition: Duration.zero,
      );
      await _savePlaybackState();
    }
  }

  Future<void> jumpToChapter(Chapter chapter) async {
    state = state.copyWith(
      currentPosition: chapter.startTime,
      currentChapterId: chapter.id,
    );
    await _savePlaybackState();
  }

  void _startProgressSimulation() {
    if (state.isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        if (state.isPlaying && state.currentPosition < state.totalDuration) {
          final newPosition = state.currentPosition + const Duration(seconds: 1);
          state = state.copyWith(currentPosition: newPosition);
          _savePlaybackState();
          _startProgressSimulation();
        }
      });
    }
  }

  // Sleep Timer functionality
  Future<void> setSleepTimer(Duration duration) async {
    Future.delayed(duration, () {
      if (state.isPlaying) {
        pause();
      }
    });
  }

  Future<void> setSleepTimerEndOfChapter() async {
    // This would need to be implemented with actual chapter data
    // For now, just set a 30-minute timer as fallback
    await setSleepTimer(const Duration(minutes: 30));
  }
}

class BookmarkService extends StateNotifier<List<Bookmark>> {
  late Box<Map> _bookmarksBox;
  
  BookmarkService() : super([]) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _bookmarksBox = await Hive.openBox<Map>('bookmarks');
      _loadBookmarks();
    } catch (e) {
      print('Error initializing bookmark service: $e');
    }
  }

  void _loadBookmarks() {
    final bookmarks = <Bookmark>[];
    
    for (final key in _bookmarksBox.keys) {
      final data = _bookmarksBox.get(key);
      if (data != null) {
        bookmarks.add(Bookmark(
          id: data['id'] ?? key,
          itemId: data['itemId'] ?? '',
          contentType: ContentType.values[data['contentType'] ?? 0],
          position: Duration(milliseconds: data['position'] ?? 0),
          note: data['note'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? 0),
          chapterId: data['chapterId'],
        ));
      }
    }
    
    // Sort by creation date (most recent first)
    bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = bookmarks;
  }

  Future<void> _saveBookmark(Bookmark bookmark) async {
    await _bookmarksBox.put(bookmark.id, {
      'id': bookmark.id,
      'itemId': bookmark.itemId,
      'contentType': bookmark.contentType.index,
      'position': bookmark.position.inMilliseconds,
      'note': bookmark.note,
      'createdAt': bookmark.createdAt.millisecondsSinceEpoch,
      'chapterId': bookmark.chapterId,
    });
  }

  Future<void> addBookmark({
    required String itemId,
    required ContentType contentType,
    required Duration position,
    String? note,
    String? chapterId,
  }) async {
    final bookmark = Bookmark(
      id: 'bookmark_${DateTime.now().millisecondsSinceEpoch}',
      itemId: itemId,
      contentType: contentType,
      position: position,
      note: note,
      createdAt: DateTime.now(),
      chapterId: chapterId,
    );
    
    state = [bookmark, ...state];
    await _saveBookmark(bookmark);
  }

  Future<void> updateBookmark(String id, {String? note}) async {
    final index = state.indexWhere((b) => b.id == id);
    if (index != -1) {
      final updatedBookmark = state[index].copyWith(note: note);
      final newState = List<Bookmark>.from(state);
      newState[index] = updatedBookmark;
      state = newState;
      await _saveBookmark(updatedBookmark);
    }
  }

  Future<void> deleteBookmark(String id) async {
    state = state.where((b) => b.id != id).toList();
    await _bookmarksBox.delete(id);
  }

  List<Bookmark> getBookmarksForItem(String itemId) {
    return state.where((b) => b.itemId == itemId).toList();
  }
}

// Providers
final audioPlayerServiceProvider = StateNotifierProvider<AudioPlayerService, PlaybackState>((ref) {
  return AudioPlayerService();
});

final bookmarkServiceProvider = StateNotifierProvider<BookmarkService, List<Bookmark>>((ref) {
  return BookmarkService();
});

// Convenience providers
final isPlayingProvider = Provider<bool>((ref) {
  return ref.watch(audioPlayerServiceProvider).isPlaying;
});

final currentPositionProvider = Provider<Duration>((ref) {
  return ref.watch(audioPlayerServiceProvider).currentPosition;
});

final playbackProgressProvider = Provider<double>((ref) {
  return ref.watch(audioPlayerServiceProvider).progress;
});

final hasCurrentItemProvider = Provider<bool>((ref) {
  return ref.watch(audioPlayerServiceProvider).hasCurrentItem;
});

// Helper functions
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  
  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

String getPlaybackSpeedText(double speed) {
  if (speed == speed.roundToDouble()) {
    return '${speed.round()}x';
  } else {
    return '${speed}x';
  }
}

IconData getRepeatModeIcon(RepeatMode mode) {
  switch (mode) {
    case RepeatMode.none:
      return Icons.repeat;
    case RepeatMode.one:
      return Icons.repeat_one;
    case RepeatMode.all:
      return Icons.repeat;
  }
}

Color getRepeatModeColor(RepeatMode mode, BuildContext context) {
  switch (mode) {
    case RepeatMode.none:
      return Theme.of(context).disabledColor;
    case RepeatMode.one:
    case RepeatMode.all:
      return Theme.of(context).primaryColor;
  }
}