import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/models/models.dart';
import '../../../core/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onRepost;
  final VoidCallback? onReply;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onRepost,
    this.onReply,
    this.onBookmark,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.xBlue,
                child: Text(
                  post.author.displayName.isNotEmpty
                      ? post.author.displayName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // User details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.author.displayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (post.author.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: AppTheme.xBlue,
                            size: 16,
                          ),
                        ],
                        const SizedBox(width: 4),
                        Text(
                          '@${post.author.username}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.xGray,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '·',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.xGray,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeago.format(post.createdAt),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.xGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // More options
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  // TODO: Show post options menu
                },
                color: AppTheme.xGray,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Post content
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.4,
            ),
          ),
          
          // Media (if any)
          if (post.mediaUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.xExtraLightGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: AppTheme.xGray,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reply
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                count: post.repliesCount,
                onTap: onReply,
              ),
              
              // Repost
              _ActionButton(
                icon: Icons.repeat,
                count: post.repostsCount,
                isActive: post.isReposted,
                activeColor: AppTheme.xGreen,
                onTap: onRepost,
              ),
              
              // Like
              _ActionButton(
                icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                count: post.likesCount,
                isActive: post.isLiked,
                activeColor: AppTheme.xRed,
                onTap: onLike,
              ),
              
              // Views
              _ActionButton(
                icon: Icons.bar_chart,
                count: post.viewsCount,
                showCount: true,
              ),
              
              // Share/Bookmark
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: post.isBookmarked ? AppTheme.xBlue : AppTheme.xGray,
                    ),
                    onPressed: onBookmark,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: onShare,
                    color: AppTheme.xGray,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;
  final bool showCount;

  const _ActionButton({
    required this.icon,
    required this.count,
    this.isActive = false,
    this.activeColor,
    this.onTap,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive && activeColor != null ? activeColor! : AppTheme.xGray;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            if (showCount && count > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count),
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}