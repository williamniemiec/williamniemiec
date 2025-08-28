import 'package:flutter/material.dart';
import '../../../shared/models/thread.dart';
import '../../home/widgets/thread_item.dart';

class ThreadSearchItem extends StatelessWidget {
  final Thread thread;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onRepost;
  final VoidCallback? onShare;

  const ThreadSearchItem({
    super.key,
    required this.thread,
    this.onTap,
    this.onLike,
    this.onReply,
    this.onRepost,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    // Reuse the ThreadItem widget from home feature
    return ThreadItem(
      thread: thread,
      onTap: onTap,
      onLike: onLike,
      onReply: onReply,
      onRepost: onRepost,
      onShare: onShare,
    );
  }
}