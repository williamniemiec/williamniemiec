import 'package:flutter/foundation.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/audio_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  
  bool _isMinimized = true;
  bool _showLyrics = false;
  bool _showQueue = false;
  double _volume = 1.0;

  bool get isMinimized => _isMinimized;
  bool get showLyrics => _showLyrics;
  bool get showQueue => _showQueue;
  double get volume => _volume;

  // Audio service getters
  Track? get currentTrack => _audioService.currentTrack;
  List<Track> get queue => _audioService.queue;
  PlayerState get playerState => _audioService.playerState;
  bool get isPlaying => _audioService.isPlaying;
  bool get isPaused => _audioService.isPaused;
  bool get isShuffleEnabled => _audioService.isShuffleEnabled;
  RepeatMode get repeatMode => _audioService.repeatMode;
  Duration get position => _audioService.position;
  Duration? get duration => _audioService.duration;
  bool get hasNext => _audioService.hasNext;
  bool get hasPrevious => _audioService.hasPrevious;

  PlayerProvider() {
    _audioService.addListener(_onAudioServiceChanged);
  }

  void _onAudioServiceChanged() {
    notifyListeners();
  }

  void toggleMinimized() {
    _isMinimized = !_isMinimized;
    notifyListeners();
  }

  void maximize() {
    _isMinimized = false;
    notifyListeners();
  }

  void minimize() {
    _isMinimized = true;
    notifyListeners();
  }

  void toggleLyrics() {
    _showLyrics = !_showLyrics;
    _showQueue = false; // Close queue if open
    notifyListeners();
  }

  void toggleQueue() {
    _showQueue = !_showQueue;
    _showLyrics = false; // Close lyrics if open
    notifyListeners();
  }

  void closeLyrics() {
    _showLyrics = false;
    notifyListeners();
  }

  void closeQueue() {
    _showQueue = false;
    notifyListeners();
  }

  Future<void> playTrack(Track track, {List<Track>? queue, int? startIndex}) async {
    await _audioService.playTrack(track, queue: queue, startIndex: startIndex);
  }

  Future<void> play() async {
    await _audioService.play();
  }

  Future<void> pause() async {
    await _audioService.pause();
  }

  Future<void> stop() async {
    await _audioService.stop();
  }

  Future<void> seekTo(Duration position) async {
    await _audioService.seekTo(position);
  }

  Future<void> skipToNext() async {
    await _audioService.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await _audioService.skipToPrevious();
  }

  void toggleShuffle() {
    _audioService.toggleShuffle();
  }

  void toggleRepeat() {
    _audioService.toggleRepeat();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _audioService.setVolume(volume);
    notifyListeners();
  }

  void addToQueue(Track track) {
    _audioService.addToQueue(track);
  }

  void removeFromQueue(int index) {
    _audioService.removeFromQueue(index);
  }

  void clearQueue() {
    _audioService.clearQueue();
  }

  // Playback progress as percentage (0.0 to 1.0)
  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration!.inMilliseconds;
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Get formatted current position
  String get formattedPosition => formatDuration(position);

  // Get formatted duration
  String get formattedDuration => duration != null ? formatDuration(duration!) : '0:00';

  @override
  void dispose() {
    _audioService.removeListener(_onAudioServiceChanged);
    super.dispose();
  }
}