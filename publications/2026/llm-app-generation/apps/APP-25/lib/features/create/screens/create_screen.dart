import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 64),
            SizedBox(height: 16),
            Text('Create Post Feature'),
            SizedBox(height: 8),
            Text('Coming Soon!'),
          ],
        ),
      ),
    );
  }
}