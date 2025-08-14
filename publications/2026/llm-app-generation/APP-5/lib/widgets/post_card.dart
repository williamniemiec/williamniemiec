import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:momentum_reddit/models/post.dart';
import 'package:momentum_reddit/screens/media_viewer_screen.dart';
import 'package:momentum_reddit/screens/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8.0),
              if (post.thumbnail != null && post.thumbnail!.startsWith('http'))
                GestureDetector(
                  onTap: () {
                    if (post.imageUrl != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MediaViewerScreen(mediaUrl: post.imageUrl!),
                        ),
                      );
                    }
                  },
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: post.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'r/${post.subreddit} • u/${post.author}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.arrow_upward, size: 16.0),
                      Text(post.score.toString()),
                      const SizedBox(width: 16.0),
                      const Icon(Icons.comment, size: 16.0),
                      Text(post.numComments.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
