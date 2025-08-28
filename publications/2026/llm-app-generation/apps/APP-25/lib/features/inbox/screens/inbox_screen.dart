import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_outlined, size: 64),
            SizedBox(height: 16),
            Text('Inbox Feature'),
            SizedBox(height: 8),
            Text('Coming Soon!'),
          ],
        ),
      ),
    );
  }
}