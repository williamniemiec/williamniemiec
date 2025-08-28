import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/video.dart';

class VideoActionsSidebar extends StatelessWidget {
  final Video video;
  final bool isLiked;
  final bool isBookmarked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onBookmark;

  const VideoActionsSidebar({
    super.key,
    required this.video,
    required this.isLiked,
    required this.isBookmarked,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onBookmark,
  });

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Creator Profile Picture
        GestureDetector(
          onTap: () {
            // TODO: Navigate to creator profile
          },
          child: Container(
            width: AppConstants.profileImageSize,
            height: AppConstants.profileImageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.textPrimaryColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: video.creator.profileImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: video.creator.profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppConstants.surfaceColor,
                        child: const Icon(
                          Icons.person,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppConstants.surfaceColor,
                        child: const Icon(
                          Icons.person,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    )
                  : Container(
                      color: AppConstants.surfaceColor,
                      child: const Icon(
                        Icons.person,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
            ),
          ),
        ),

        // Follow Button (if not following)
        if (!video.creator.isFollowing) ...[
          const SizedBox(height: 8),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppConstants.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Like Button
        _ActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          count: _formatCount(video.likesCount + (isLiked ? 1 : 0)),
          onTap: onLike,
          isActive: isLiked,
        ),

        const SizedBox(height: 16),

        // Comment Button
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          count: _formatCount(video.commentsCount),
          onTap: onComment,
        ),

        const SizedBox(height: 16),

        // Bookmark Button
        _ActionButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          count: '',
          onTap: onBookmark,
          isActive: isBookmarked,
        ),

        const SizedBox(height: 16),

        // Share Button
        _ActionButton(
          icon: Icons.share,
          count: _formatCount(video.sharesCount),
          onTap: onShare,
        ),

        const SizedBox(height: 24),

        // Sound Icon (spinning record)
        GestureDetector(
          onTap: () {
            // TODO: Navigate to sound page
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.secondaryColor,
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String count;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppConstants.primaryColor : AppConstants.iconColor,
            size: 32,
          ),
          if (count.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                color: AppConstants.textPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}