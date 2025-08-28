import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';

class PostCard extends StatelessWidget {
  final RedditPost post;
  final Function(VoteStatus) onVote;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onVote,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: AppConstants.smallPadding / 2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: AppConstants.smallPadding),
              
              // Title
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Content preview
              if (post.hasText) ...[
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  post.content!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              // Media
              if (post.hasMedia) ...[
                const SizedBox(height: AppConstants.smallPadding),
                _buildMedia(context),
              ],
              
              // External link
              if (post.isExternalLink) ...[
                const SizedBox(height: AppConstants.smallPadding),
                _buildExternalLink(context),
              ],
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Actions
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Subreddit icon
        CircleAvatar(
          radius: 12,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            post.subreddit.displayName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        
        // Subreddit and author info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'r/${post.subreddit.displayName}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    ' • ${post.timeAgo}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                'u/${post.author.username}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Post menu
        IconButton(
          icon: const Icon(Icons.more_horiz),
          iconSize: 20,
          onPressed: () => _showPostMenu(context),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    if (post.media?.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: CachedNetworkImage(
          imageUrl: post.media!.imageUrl!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 200,
            color: Theme.of(context).colorScheme.surface,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Theme.of(context).colorScheme.surface,
            child: const Center(
              child: Icon(Icons.broken_image),
            ),
          ),
        ),
      );
    }
    
    if (post.gallery != null && post.gallery!.isNotEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.photo_library, size: 48),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                '${post.gallery!.length} images',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildExternalLink(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.borderColor,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.link, size: 20),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              post.domain ?? post.url ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Vote buttons
        _buildVoteButton(
          context,
          Icons.arrow_upward,
          post.userVote == VoteStatus.upvoted,
          () => onVote(post.userVote == VoteStatus.upvoted 
              ? VoteStatus.none 
              : VoteStatus.upvoted),
          Theme.of(context).colorScheme.upvoteColor,
        ),
        const SizedBox(width: 4),
        
        // Score
        Text(
          post.formattedScore,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: post.userVote == VoteStatus.upvoted
                ? Theme.of(context).colorScheme.upvoteColor
                : post.userVote == VoteStatus.downvoted
                    ? Theme.of(context).colorScheme.downvoteColor
                    : null,
          ),
        ),
        const SizedBox(width: 4),
        
        _buildVoteButton(
          context,
          Icons.arrow_downward,
          post.userVote == VoteStatus.downvoted,
          () => onVote(post.userVote == VoteStatus.downvoted 
              ? VoteStatus.none 
              : VoteStatus.downvoted),
          Theme.of(context).colorScheme.downvoteColor,
        ),
        
        const SizedBox(width: AppConstants.defaultPadding),
        
        // Comments
        _buildActionButton(
          context,
          Icons.comment_outlined,
          '${post.commentCount}',
          () => onTap(),
        ),
        
        const Spacer(),
        
        // Share
        _buildActionButton(
          context,
          Icons.share_outlined,
          'Share',
          () => _sharePost(context),
        ),
        
        const SizedBox(width: AppConstants.smallPadding),
        
        // Save
        _buildActionButton(
          context,
          post.isSaved ? Icons.bookmark : Icons.bookmark_border,
          post.isSaved ? 'Saved' : 'Save',
          onSave,
          isActive: post.isSaved,
        ),
      ],
    );
  }

  Widget _buildVoteButton(
    BuildContext context,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
    Color activeColor,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? activeColor : Theme.of(context).colorScheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.hide_source),
            title: const Text('Hide'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block user'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _sharePost(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality not implemented')),
    );
  }
}