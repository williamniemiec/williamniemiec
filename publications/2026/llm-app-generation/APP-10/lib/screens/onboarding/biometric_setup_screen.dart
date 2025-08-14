import 'package:flutter/material.dart';

class BiometricSetupScreen extends StatelessWidget {
  final VoidCallback onNext;

  const BiometricSetupScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Biometric Setup'),
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}