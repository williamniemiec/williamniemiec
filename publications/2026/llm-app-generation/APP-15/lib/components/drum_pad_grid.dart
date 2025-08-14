import 'package:flutter/material.dart';
import 'package:flutter_haptic/haptic.dart';
import 'package:rhythm_pad/audio/audio_engine.dart';
import 'package:rhythm_pad/audio/sequencer.dart';
import 'package:rhythm_pad/components/drum_pad.dart';

class DrumPadGrid extends StatefulWidget {
  final Sequencer sequencer;

  const DrumPadGrid({required this.sequencer});

  @override
  _DrumPadGridState createState() => _DrumPadGridState();
}

class _DrumPadGridState extends State<DrumPadGrid> {
  final AudioEngine _audioEngine = AudioEngine();
  final List<bool> _isPressed = List.generate(16, (_) => false);
  final List<String> _sounds = [
    'audio/kick.wav',
    'audio/snare.wav',
    'audio/hat.wav',
    'audio/kick.wav',
    'audio/snare.wav',
    'audio/hat.wav',
    'audio/kick.wav',
    'audio/snare.wav',
    'audio/hat.wav',
    'audio/kick.wav',
    'audio/snare.wav',
    'audio/hat.wav',
    'audio/kick.wav',
    'audio/snare.wav',
    'audio/hat.wav',
    'audio/kick.wav',
  ];

  void _onPadTap(int index) {
    Haptic.onSuccess();
    _audioEngine.playSound(_sounds[index]);
    widget.sequencer.record(index);
    setState(() {
      _isPressed[index] = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isPressed[index] = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 16,
      itemBuilder: (context, index) {
        return DrumPad(
          isPressed: _isPressed[index],
          onTap: () => _onPadTap(index),
        );
      },
    );
  }
}