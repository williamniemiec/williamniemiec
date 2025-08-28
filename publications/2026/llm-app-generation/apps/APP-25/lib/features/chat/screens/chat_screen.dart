import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64),
            SizedBox(height: 16),
            Text('Chat Feature'),
            SizedBox(height: 8),
            Text('Coming Soon!'),
          ],
        ),
      ),
    );
  }
}