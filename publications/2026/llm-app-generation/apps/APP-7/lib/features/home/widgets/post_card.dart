import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/post.dart';
import '../../../core/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final ValueChanged<String>? onAppreciate;
  final ValueChanged<String>? onComment;
  final ValueChanged<String>? onShare;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onAppreciate,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.sm),
              _buildContent(context),
              if (post.attachments.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildAttachments(context),
              ],
              const SizedBox(height: AppSpacing.sm),
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
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.primaryColor,
          backgroundImage: post.authorImageUrl != null
              ? NetworkImage(post.authorImageUrl!)
              : null,
          child: post.authorImageUrl == null
              ? Text(
                  post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.authorName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(post.authorRole),
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Text(
                      post.authorRole,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    _formatDateTime(post.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    _getAudienceIcon(post.audience),
                    size: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    post.audience.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (post.isUrgent)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.urgentColor,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.priority_high,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 2),
                Text(
                  'URGENT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.title.isNotEmpty) ...[
          Text(
            post.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(
          post.content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAttachments(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.attachments.length,
        itemBuilder: (context, index) {
          final attachment = post.attachments[index];
          return Container(
            width: 80,
            margin: EdgeInsets.only(
              right: index < post.attachments.length - 1 ? AppSpacing.sm : 0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Center(
              child: Icon(
                _getAttachmentIcon(attachment.type),
                size: 32,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          context,
          icon: Icons.favorite_outline,
          label: post.appreciationCount.toString(),
          onTap: onAppreciate != null ? () => onAppreciate!(post.id) : null,
        ),
        const SizedBox(width: AppSpacing.md),
        _buildActionButton(
          context,
          icon: Icons.comment_outlined,
          label: post.commentCount.toString(),
          onTap: onComment != null ? () => onComment!(post.id) : null,
        ),
        const Spacer(),
        _buildActionButton(
          context,
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShare != null ? () => onShare!(post.id) : null,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'teacher':
        return AppTheme.primaryColor;
      case 'principal':
      case 'admin':
        return AppTheme.secondaryColor;
      case 'staff':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getAudienceIcon(PostAudience audience) {
    switch (audience) {
      case PostAudience.district:
        return Icons.account_balance;
      case PostAudience.school:
        return Icons.school;
      case PostAudience.grade:
        return Icons.grade;
      case PostAudience.classroom:
        return Icons.class_;
      case PostAudience.group:
        return Icons.group;
    }
  }

  IconData _getAttachmentIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.video:
        return Icons.video_file;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.audio:
        return Icons.audio_file;
      case AttachmentType.link:
        return Icons.link;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }
}