import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/models/thread.dart';
import '../../../core/constants/app_constants.dart';

class ThreadItem extends StatelessWidget {
  final Thread thread;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onRepost;
  final VoidCallback? onShare;
  final VoidCallback? onTap;

  const ThreadItem({
    super.key,
    required this.thread,
    this.onLike,
    this.onReply,
    this.onRepost,
    this.onShare,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
            // Header with user info
            Row(
              children: [
                _buildAvatar(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            thread.author.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (thread.author.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                          const SizedBox(width: 8),
                          Text(
                            '@${thread.author.username}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeago.format(thread.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildMoreButton(context),
              ],
            ),
            const SizedBox(height: 12),
            
            // Thread content
            if (thread.content.isNotEmpty) ...[
              Text(
                thread.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],
            
            // Media attachments
            if (thread.hasAttachments) ...[
              _buildMediaAttachments(context),
              const SizedBox(height: 12),
            ],
            
            // Quoted thread
            if (thread.quotedThread != null) ...[
              _buildQuotedThread(context),
              const SizedBox(height: 12),
            ],
            
            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: AppConstants.avatarSize / 2,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: thread.author.profileImageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.avatarSize / 2),
              child: CachedNetworkImage(
                imageUrl: thread.author.profileImageUrl!,
                width: AppConstants.avatarSize,
                height: AppConstants.avatarSize,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            )
          : Icon(
              Icons.person,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return IconButton(
      onPressed: () => _showMoreOptions(context),
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildMediaAttachments(BuildContext context) {
    if (thread.attachments.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: thread.attachments.length == 1
            ? _buildSingleMedia(context, thread.attachments.first)
            : _buildMultipleMedia(context),
      ),
    );
  }

  Widget _buildSingleMedia(BuildContext context, MediaAttachment attachment) {
    if (attachment.type == 'image') {
      return CachedNetworkImage(
        imageUrl: attachment.url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surface,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.surface,
          child: const Center(child: Icon(Icons.error)),
        ),
      );
    } else {
      // Video placeholder
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(
          child: Icon(Icons.play_circle_outline, size: 48),
        ),
      );
    }
  }

  Widget _buildMultipleMedia(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: thread.attachments.length.clamp(0, 4),
      itemBuilder: (context, index) {
        final attachment = thread.attachments[index];
        return _buildSingleMedia(context, attachment);
      },
    );
  }

  Widget _buildQuotedThread(BuildContext context) {
    final quoted = thread.quotedThread!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: quoted.author.profileImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: quoted.author.profileImageUrl!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                quoted.author.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '@${quoted.author.username}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            quoted.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          context,
          icon: Icons.favorite_outline,
          activeIcon: Icons.favorite,
          isActive: thread.isLiked,
          count: thread.likesCount,
          onTap: onLike,
          activeColor: Colors.red,
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          context,
          icon: Icons.chat_bubble_outline,
          count: thread.repliesCount,
          onTap: onReply,
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          context,
          icon: Icons.repeat,
          isActive: thread.isReposted,
          count: thread.repostsCount,
          onTap: onRepost,
          activeColor: Colors.green,
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          context,
          icon: Icons.share_outlined,
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    IconData? activeIcon,
    bool isActive = false,
    int? count,
    VoidCallback? onTap,
    Color? activeColor,
  }) {
    final color = isActive && activeColor != null
        ? activeColor
        : Theme.of(context).textTheme.bodySmall?.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive && activeIcon != null ? activeIcon : icon,
              size: 20,
              color: color,
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Text(
                _formatCount(count),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy link'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement copy link
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Report thread'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement report
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block user'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement block user
              },
            ),
          ],
        ),
      ),
    );
  }
}