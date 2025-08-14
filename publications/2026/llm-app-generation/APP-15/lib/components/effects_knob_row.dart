import 'package:flutter/material.dart';
import 'package:rhythm_pad/components/effects_knob.dart';

class EffectsKnobRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        EffectsKnob(
          label: 'FILTER',
          onChanged: (value) {
            // Handle filter change
          },
        ),
        EffectsKnob(
          label: 'REVERB',
          onChanged: (value) {
            // Handle reverb change
          },
        ),
        EffectsKnob(
          label: 'DELAY',
          onChanged: (value) {
            // Handle delay change
          },
        ),
      ],
    );
  }
}