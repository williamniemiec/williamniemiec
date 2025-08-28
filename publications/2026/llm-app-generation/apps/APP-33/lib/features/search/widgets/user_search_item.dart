import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/models/user.dart';
import '../../../core/constants/app_constants.dart';

class UserSearchItem extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onFollow;
  final VoidCallback? onUnfollow;
  final bool isFollowing;

  const UserSearchItem({
    super.key,
    required this.user,
    this.onTap,
    this.onFollow,
    this.onUnfollow,
    this.isFollowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: 12,
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: user.profileImageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CachedNetworkImage(
                        imageUrl: user.profileImageUrl!,
                        width: 48,
                        height: 48,
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
            ),
            const SizedBox(width: 12),
            
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.displayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.bio!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${_formatCount(user.followersCount)} followers',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            
            // Follow button
            const SizedBox(width: 12),
            _buildFollowButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    if (isFollowing) {
      return OutlinedButton(
        onPressed: onUnfollow,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(80, 32),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          side: BorderSide(
            color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
          ),
        ),
        child: Text(
          'Following',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onFollow,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(80, 32),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Text(
        'Follow',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}