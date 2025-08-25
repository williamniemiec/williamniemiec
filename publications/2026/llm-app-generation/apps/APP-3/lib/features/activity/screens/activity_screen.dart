import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/activity.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: () {
              // Mark all as read
            },
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
          IconButton(
            onPressed: () {
              // Filter activities
            },
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: _buildActivityList(),
    );
  }

  Widget _buildActivityList() {
    // Mock data for demonstration
    final mockActivities = [
      Activity(
        id: '1',
        type: ActivityType.mention,
        title: 'John mentioned you',
        description: 'in Marketing Team - General channel',
        actorName: 'John Doe',
        targetName: 'Marketing Team',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        priority: ActivityPriority.high,
      ),
      Activity(
        id: '2',
        type: ActivityType.message,
        title: 'New message in Project Alpha',
        description: 'Sarah: The design mockups are ready for review',
        actorName: 'Sarah Wilson',
        targetName: 'Project Alpha',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        priority: ActivityPriority.normal,
      ),
      Activity(
        id: '3',
        type: ActivityType.meeting,
        title: 'Meeting starting soon',
        description: 'Weekly Team Sync in 15 minutes',
        timestamp: DateTime.now().add(const Duration(minutes: 15)),
        priority: ActivityPriority.high,
      ),
      Activity(
        id: '4',
        type: ActivityType.file,
        title: 'File shared',
        description: 'Mike shared "Q4 Report.pdf" in Finance Team',
        actorName: 'Mike Johnson',
        targetName: 'Finance Team',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        priority: ActivityPriority.normal,
      ),
    ];

    if (mockActivities.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: mockActivities.length,
      itemBuilder: (context, index) {
        final activity = mockActivities[index];
        return _buildActivityItem(activity);
      },
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildActivityIcon(activity.type),
        title: Text(
          activity.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: activity.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.description),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(activity.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        trailing: activity.priority == ActivityPriority.high
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.errorRed,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Handle activity tap
          _handleActivityTap(activity);
        },
      ),
    );
  }

  Widget _buildActivityIcon(ActivityType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case ActivityType.mention:
        iconData = Icons.alternate_email;
        iconColor = AppTheme.errorRed;
        break;
      case ActivityType.message:
        iconData = Icons.chat_bubble_outline;
        iconColor = AppTheme.primaryBlue;
        break;
      case ActivityType.meeting:
        iconData = Icons.video_call;
        iconColor = AppTheme.successGreen;
        break;
      case ActivityType.file:
        iconData = Icons.attach_file;
        iconColor = AppTheme.warningOrange;
        break;
      case ActivityType.call:
        iconData = Icons.call;
        iconColor = AppTheme.successGreen;
        break;
      case ActivityType.teamUpdate:
        iconData = Icons.groups;
        iconColor = AppTheme.primaryBlue;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.primaryBlue;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppTheme.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No activity yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you have notifications, they\'ll appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleActivityTap(Activity activity) {
    // Navigate based on activity type
    switch (activity.type) {
      case ActivityType.mention:
      case ActivityType.message:
        // Navigate to chat/channel
        break;
      case ActivityType.meeting:
        // Navigate to meeting or show meeting details
        break;
      case ActivityType.file:
        // Open file or navigate to files
        break;
      default:
        // Handle other activity types
        break;
    }
  }
}