import 'package:flutter/material.dart';

class SubredditScreen extends StatelessWidget {
  final String subredditName;

  const SubredditScreen({
    super.key,
    required this.subredditName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('r/$subredditName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.forum_outlined, size: 64),
            const SizedBox(height: 16),
            Text('Subreddit: r/$subredditName'),
            const SizedBox(height: 8),
            const Text('Coming Soon!'),
          ],
        ),
      ),
    );
  }
}