import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/models.dart';

enum PlayerState {
  stopped,
  playing,
  paused,
  buffering,
  loading,
  error,
}

enum RepeatMode {
  off,
  one,
  all,
}

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController = StreamController<Duration?>.broadcast();
  final StreamController<PlayerState> _playerStateController = StreamController<PlayerState>.broadcast();

  // Current playback state
  Track? _currentTrack;
  List<Track> _queue = [];
  int _currentIndex = 0;
  PlayerState _playerState = PlayerState.stopped;
  bool _isShuffleEnabled = false;
  RepeatMode _repeatMode = RepeatMode.off;
  double _volume = 1.0;
  Duration _position = Duration.zero;
  Duration? _duration;

  // Getters
  Track? get currentTrack => _currentTrack;
  List<Track> get queue => List.unmodifiable(_queue);
  int get currentIndex => _currentIndex;
  PlayerState get playerState => _playerState;
  bool get isShuffleEnabled => _isShuffleEnabled;
  RepeatMode get repeatMode => _repeatMode;
  double get volume => _volume;
  Duration get position => _position;
  Duration? get duration => _duration;
  bool get isPlaying => _playerState == PlayerState.playing;
  bool get isPaused => _playerState == PlayerState.paused;
  bool get hasNext => _currentIndex < _queue.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  // Streams
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration?> get durationStream => _durationController.stream;
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  Future<void> initialize() async {
    try {
      // Initialize audio session
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) async {
        switch (state.processingState) {
          case ProcessingState.idle:
            _updatePlayerState(PlayerState.stopped);
            break;
          case ProcessingState.loading:
            _updatePlayerState(PlayerState.loading);
            break;
          case ProcessingState.buffering:
            _updatePlayerState(PlayerState.buffering);
            break;
          case ProcessingState.ready:
            if (state.playing) {
              _updatePlayerState(PlayerState.playing);
            } else {
              _updatePlayerState(PlayerState.paused);
            }
            break;
          case ProcessingState.completed:
            await _handleTrackCompleted();
            break;
        }
      });

      // Listen to position changes
      _audioPlayer.positionStream.listen((position) {
        _position = position;
        _positionController.add(position);
        notifyListeners();
      });

      // Listen to duration changes
      _audioPlayer.durationStream.listen((duration) {
        _duration = duration;
        _durationController.add(duration);
        notifyListeners();
      });

      debugPrint('AudioService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AudioService: $e');
      _updatePlayerState(PlayerState.error);
    }
  }

  Future<void> playTrack(Track track, {List<Track>? queue, int? startIndex}) async {
    try {
      if (queue != null) {
        _queue = queue;
        _currentIndex = startIndex ?? 0;
      } else {
        _queue = [track];
        _currentIndex = 0;
      }

      _currentTrack = track;
      _updatePlayerState(PlayerState.loading);

      await _audioPlayer.setUrl(track.audioUrl);
      await _audioPlayer.play();

      notifyListeners();
    } catch (e) {
      debugPrint('Error playing track: $e');
      _updatePlayerState(PlayerState.error);
    }
  }

  Future<void> play() async {
    try {
      if (_currentTrack != null) {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error playing: $e');
      _updatePlayerState(PlayerState.error);
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentTrack = null;
      _position = Duration.zero;
      _duration = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  Future<void> skipToNext() async {
    if (!hasNext && _repeatMode != RepeatMode.all) return;

    try {
      int nextIndex;
      if (_isShuffleEnabled) {
        nextIndex = _getRandomIndex();
      } else if (hasNext) {
        nextIndex = _currentIndex + 1;
      } else if (_repeatMode == RepeatMode.all) {
        nextIndex = 0;
      } else {
        return;
      }

      _currentIndex = nextIndex;
      _currentTrack = _queue[_currentIndex];
      
      await _audioPlayer.setUrl(_currentTrack!.audioUrl);
      await _audioPlayer.play();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error skipping to next: $e');
      _updatePlayerState(PlayerState.error);
    }
  }

  Future<void> skipToPrevious() async {
    if (!hasPrevious && _repeatMode != RepeatMode.all) return;

    try {
      int previousIndex;
      if (_isShuffleEnabled) {
        previousIndex = _getRandomIndex();
      } else if (hasPrevious) {
        previousIndex = _currentIndex - 1;
      } else if (_repeatMode == RepeatMode.all) {
        previousIndex = _queue.length - 1;
      } else {
        return;
      }

      _currentIndex = previousIndex;
      _currentTrack = _queue[_currentIndex];
      
      await _audioPlayer.setUrl(_currentTrack!.audioUrl);
      await _audioPlayer.play();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error skipping to previous: $e');
      _updatePlayerState(PlayerState.error);
    }
  }

  void toggleShuffle() {
    _isShuffleEnabled = !_isShuffleEnabled;
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  void addToQueue(Track track) {
    _queue.add(track);
    notifyListeners();
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      if (index < _currentIndex) {
        _currentIndex--;
      } else if (index == _currentIndex && _queue.isNotEmpty) {
        // If we removed the current track, play the next one
        if (_currentIndex >= _queue.length) {
          _currentIndex = _queue.length - 1;
        }
        if (_queue.isNotEmpty) {
          playTrack(_queue[_currentIndex]);
        }
      }
      notifyListeners();
    }
  }

  void clearQueue() {
    _queue.clear();
    _currentIndex = 0;
    notifyListeners();
  }

  void _updatePlayerState(PlayerState state) {
    _playerState = state;
    _playerStateController.add(state);
    notifyListeners();
  }

  Future<void> _handleTrackCompleted() async {
    if (_repeatMode == RepeatMode.one) {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } else if (hasNext || _repeatMode == RepeatMode.all) {
      await skipToNext();
    } else {
      _updatePlayerState(PlayerState.stopped);
    }
  }

  int _getRandomIndex() {
    if (_queue.length <= 1) return 0;
    int randomIndex;
    do {
      randomIndex = (DateTime.now().millisecondsSinceEpoch % _queue.length);
    } while (randomIndex == _currentIndex);
    return randomIndex;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionController.close();
    _durationController.close();
    _playerStateController.close();
    super.dispose();
  }
}