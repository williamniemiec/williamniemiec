import 'package:flutter/material.dart';
import 'package:rhythm_pad/audio/sequencer.dart';

class PatternSelector extends StatelessWidget {
  final Sequencer sequencer;

  const PatternSelector({required this.sequencer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(8, (index) {
        return ElevatedButton(
          onPressed: () {
            sequencer.setPattern(index);
          },
          child: Text('${index + 1}'),
        );
      }),
    );
  }
}