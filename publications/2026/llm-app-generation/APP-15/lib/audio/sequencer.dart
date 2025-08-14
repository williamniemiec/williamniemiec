import 'dart:async';
import 'package:rhythm_pad/audio/audio_engine.dart';

class Sequencer {
  final AudioEngine _audioEngine;
  Timer? _timer;
  int _step = 0;
  double _bpm = 120.0;
  bool _isPlaying = false;
  List<List<bool>> _patterns = List.generate(8, (_) => List.generate(16, (_) => false));
  int _currentPattern = 0;

  Sequencer(this._audioEngine);

  void _onStep() {
    for (int i = 0; i < 16; i++) {
      if (_patterns[_currentPattern][i] && _step % 16 == i) {
        _audioEngine.playSound('audio/hat.wav');
      }
    }
    _step++;
  }

  void play() {
    if (_isPlaying) return;
    _isPlaying = true;
    _timer = Timer.periodic(Duration(milliseconds: (60000 / _bpm / 4).round()), (timer) {
      _onStep();
    });
  }

  void stop() {
    _timer?.cancel();
    _isPlaying = false;
    _step = 0;
  }

  void record(int padIndex) {
    _patterns[_currentPattern][padIndex] = !_patterns[_currentPattern][padIndex];
  }

  void setPattern(int patternIndex) {
    _currentPattern = patternIndex;
  }
}