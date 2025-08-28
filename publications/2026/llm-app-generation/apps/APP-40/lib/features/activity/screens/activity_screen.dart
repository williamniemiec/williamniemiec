import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/activity.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMockData();
      }
    });
  }

  void _loadMockData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    final mockActivities = [
      Activity(
        id: '1',
        type: ActivityType.securityEvent,
        title: 'Person detected at Front Door',
        description: 'Motion detected by Front Door Camera',
        priority: ActivityPriority.high,
        deviceId: '3',
        metadata: {'confidence': 0.95, 'duration': 5},
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Activity(
        id: '2',
        type: ActivityType.routineTriggered,
        title: 'Good Morning routine activated',
        description: 'Lights turned on, thermostat adjusted',
        priority: ActivityPriority.medium,
        routineId: '1',
        metadata: {'actionsCompleted': 2, 'totalActions': 2},
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Activity(
        id: '3',
        type: ActivityType.deviceStateChange,
        title: 'Living Room Light turned on',
        description: 'Brightness set to 80%',
        priority: ActivityPriority.low,
        deviceId: '1',
        metadata: {'brightness': 80, 'previousState': 'off'},
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Activity(
        id: '4',
        type: ActivityType.mediaPlayback,
        title: 'Music started playing',
        description: 'Playing on Kitchen Speaker',
        priority: ActivityPriority.low,
        deviceId: '4',
        metadata: {'song': 'Bohemian Rhapsody', 'artist': 'Queen'},
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Activity(
        id: '5',
        type: ActivityType.systemNotification,
        title: 'Device update available',
        description: 'Smart Lock firmware update ready',
        priority: ActivityPriority.medium,
        deviceId: '6',
        metadata: {'version': '2.1.3', 'size': '15MB'},
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Activity(
        id: '6',
        type: ActivityType.userAction,
        title: 'New device added',
        description: 'Bedroom Light successfully configured',
        priority: ActivityPriority.low,
        deviceId: '5',
        metadata: {'setupTime': 120, 'room': 'bedroom'},
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    appProvider.setActivities(mockActivities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  title: Text(
                    'Activity',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterDialog(context),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(value, appProvider),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'mark_all_read',
                          child: Text('Mark all as read'),
                        ),
                        const PopupMenuItem(
                          value: 'clear_all',
                          child: Text('Clear all'),
                        ),
                      ],
                    ),
                  ],
                ),

                // Activity Summary
                SliverToBoxAdapter(
                  child: _buildActivitySummary(appProvider),
                ),

                // Activity List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final activities = appProvider.activities;
                      if (index < activities.length) {
                        final activity = activities[index];
                        return _buildActivityCard(activity, appProvider);
                      }
                      return null;
                    },
                    childCount: appProvider.activities.length,
                  ),
                ),

                // Empty state
                if (appProvider.activities.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivitySummary(AppProvider appProvider) {
    final totalActivities = appProvider.activities.length;
    final unreadActivities = appProvider.unreadActivities.length;
    final criticalActivities = appProvider.criticalActivities.length;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              context,
              'Total',
              totalActivities.toString(),
              Icons.timeline,
              Theme.of(context).colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          Expanded(
            child: _buildSummaryItem(
              context,
              'Unread',
              unreadActivities.toString(),
              Icons.circle,
              Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          Expanded(
            child: _buildSummaryItem(
              context,
              'Critical',
              criticalActivities.toString(),
              Icons.warning,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Activity activity, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Card(
        child: InkWell(
          onTap: () => _onActivityTap(activity, appProvider),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getActivityColor(activity.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getActivityIcon(activity.type),
                    color: _getActivityColor(activity.type),
                    size: 20,
                  ),
                ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!activity.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(activity.priority).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              activity.priorityDisplayName,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: _getPriorityColor(activity.priority),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            activity.timeAgo,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'No activity yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Device events and notifications will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.deviceStateChange:
        return MdiIcons.devices;
      case ActivityType.routineTriggered:
        return MdiIcons.autorenew;
      case ActivityType.securityEvent:
        return MdiIcons.shield;
      case ActivityType.mediaPlayback:
        return MdiIcons.play;
      case ActivityType.userAction:
        return MdiIcons.account;
      case ActivityType.systemNotification:
        return MdiIcons.bell;
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.deviceStateChange:
        return Colors.blue;
      case ActivityType.routineTriggered:
        return Colors.green;
      case ActivityType.securityEvent:
        return Colors.red;
      case ActivityType.mediaPlayback:
        return Colors.purple;
      case ActivityType.userAction:
        return Colors.orange;
      case ActivityType.systemNotification:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(ActivityPriority priority) {
    switch (priority) {
      case ActivityPriority.low:
        return Colors.green;
      case ActivityPriority.medium:
        return Colors.orange;
      case ActivityPriority.high:
        return Colors.red;
      case ActivityPriority.critical:
        return Colors.red.shade800;
    }
  }

  void _onActivityTap(Activity activity, AppProvider appProvider) {
    if (!activity.isRead) {
      appProvider.markActivityAsRead(activity.id);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opened ${activity.title}')),
    );
  }

  void _handleMenuAction(String action, AppProvider appProvider) {
    switch (action) {
      case 'mark_all_read':
        appProvider.markAllActivitiesAsRead();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All activities marked as read')),
        );
        break;
      case 'clear_all':
        _showClearAllDialog(appProvider);
        break;
    }
  }

  void _showClearAllDialog(AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Activities'),
        content: const Text('Are you sure you want to clear all activities? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appProvider.clearActivities();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All activities cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Activities'),
        content: const Text('Activity filtering options would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}