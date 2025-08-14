import 'package:audioplayers/audioplayers.dart';

class AudioEngine {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(String soundPath) async {
    await _audioPlayer.play(AssetSource(soundPath));
  }
}