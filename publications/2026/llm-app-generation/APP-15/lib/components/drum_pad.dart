import 'package:flutter/material.dart';
import 'package:rhythm_pad/components/sound_selection_panel.dart';

class DrumPad extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPressed;

  const DrumPad({
    required this.onTap,
    this.isPressed = false,
  });

  void _openSoundSelectionPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SoundSelectionPanel();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _openSoundSelectionPanel(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: isPressed ? Colors.grey[700] : Colors.grey[800],
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: const Center(
          child: Text(
            'PAD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}