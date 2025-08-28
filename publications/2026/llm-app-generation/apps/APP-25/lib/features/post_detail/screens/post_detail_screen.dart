import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64),
            const SizedBox(height: 16),
            Text('Post Detail: $postId'),
            const SizedBox(height: 8),
            const Text('Coming Soon!'),
          ],
        ),
      ),
    );
  }
}