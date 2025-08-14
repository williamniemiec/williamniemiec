import 'package:flutter/material.dart';

class EffectsKnob extends StatefulWidget {
  final String label;
  final ValueChanged<double> onChanged;

  const EffectsKnob({
    required this.label,
    required this.onChanged,
  });

  @override
  _EffectsKnobState createState() => _EffectsKnobState();
}

class _EffectsKnobState extends State<EffectsKnob> {
  double _value = 0.0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _value += details.delta.dy / 100;
      _value = _value.clamp(0.0, 1.0);
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[700],
            ),
            child: Center(
              child: Text(
                _value.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}