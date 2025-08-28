import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String channelId;
  final String? channelName;

  const ChatScreen({
    super.key,
    required this.channelId,
    this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(channelName ?? 'Chat')),
      body: Center(child: Text('Chat Screen - Channel ID: $channelId')),
    );
  }
}