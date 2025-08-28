import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../shared/models/activity.dart';
import '../../../core/constants/app_constants.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const ActivityItem({
    super.key,
    required this.activity,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: activity.isRead 
              ? Colors.transparent 
              : Theme.of(context).colorScheme.primary.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Actor avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: activity.actor.profileImageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: activity.actor.profileImageUrl!,
                        width: 40,
                        height: 40,
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
            
            // Activity content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity description
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: activity.actor.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (activity.actor.isVerified) ...[
                          const TextSpan(text: ' '),
                          WidgetSpan(
                            child: Icon(
                              Icons.verified,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                        TextSpan(text: ' ${activity.actionText}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Thread content (if applicable)
                  if (activity.thread != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        activity.thread!.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  
                  // Reply content (if applicable)
                  if (activity.content != null && activity.content!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        activity.content!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
                  // Timestamp
                  Text(
                    timeago.format(activity.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            
            // Activity type icon and unread indicator
            Column(
              children: [
                _buildActivityIcon(context),
                if (!activity.isRead) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(BuildContext context) {
    IconData iconData;
    Color? iconColor;

    switch (activity.type) {
      case ActivityType.like:
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;
      case ActivityType.reply:
        iconData = Icons.chat_bubble;
        iconColor = Theme.of(context).primaryColor;
        break;
      case ActivityType.repost:
        iconData = Icons.repeat;
        iconColor = Colors.green;
        break;
      case ActivityType.quote:
        iconData = Icons.format_quote;
        iconColor = Theme.of(context).primaryColor;
        break;
      case ActivityType.follow:
        iconData = Icons.person_add;
        iconColor = Theme.of(context).primaryColor;
        break;
      case ActivityType.mention:
        iconData = Icons.alternate_email;
        iconColor = Theme.of(context).primaryColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: iconColor?.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 16,
        color: iconColor,
      ),
    );
  }
}