import 'package:flutter/material.dart';
import 'package:rhythm_pad/audio/sequencer.dart';

class TransportControls extends StatelessWidget {
  final Sequencer sequencer;

  const TransportControls({required this.sequencer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: sequencer.play,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: sequencer.stop,
        ),
        IconButton(
          icon: const Icon(Icons.fiber_manual_record),
          onPressed: () {
            // The record functionality is handled by tapping the pads
          },
        ),
      ],
    );
  }
}