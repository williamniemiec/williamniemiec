import 'package:flutter/material.dart';
import 'package:rhythm_pad/audio/audio_engine.dart';
import 'package:rhythm_pad/audio/sequencer.dart';
import 'package:rhythm_pad/components/drum_pad_grid.dart';
import 'package:rhythm_pad/components/effects_knob_row.dart';
import 'package:rhythm_pad/components/pattern_selector.dart';
import 'package:rhythm_pad/components/transport_controls.dart';

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  late final Sequencer _sequencer;

  @override
  void initState() {
    super.initState();
    _sequencer = Sequencer(AudioEngine());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rhythm Pad'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Effects Knobs
            Container(
              height: 100,
              color: Colors.grey[800],
              child: EffectsKnobRow(),
            ),
            
            // Drum Pad Grid
            Expanded(
              child: DrumPadGrid(sequencer: _sequencer),
            ),
            
            // Transport and Pattern Controls
            Container(
              height: 100,
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TransportControls(sequencer: _sequencer),
                  PatternSelector(sequencer: _sequencer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}