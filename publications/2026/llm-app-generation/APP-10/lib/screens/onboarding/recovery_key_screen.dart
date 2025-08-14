import 'package:flutter/material.dart';

class RecoveryKeyScreen extends StatelessWidget {
  final VoidCallback onNext;

  const RecoveryKeyScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Recovery Key'),
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}