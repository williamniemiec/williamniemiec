import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final double strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password Strength',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: strength,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getColor(strength),
          ),
        ),
      ],
    );
  }

  Color _getColor(double strength) {
    if (strength < 0.3) {
      return Colors.red;
    } else if (strength < 0.6) {
      return Colors.orange;
    } else if (strength < 0.8) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}