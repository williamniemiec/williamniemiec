import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/activity_item.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      if (appProvider.activities.isEmpty) {
        appProvider.loadActivities(refresh: true);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      context.read<AppProvider>().loadActivities();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<AppProvider>().loadActivities(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.error != null) {
            return _buildErrorState(appProvider.error!);
          }

          if (appProvider.activities.isEmpty && appProvider.isLoading) {
            return _buildLoadingState();
          }

          if (appProvider.activities.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
              itemCount: appProvider.activities.length + (appProvider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= appProvider.activities.length) {
                  return _buildLoadingIndicator();
                }

                final activity = appProvider.activities[index];
                return ActivityItem(
                  activity: activity,
                  onTap: () => _handleActivityTap(activity),
                  onMarkAsRead: () => appProvider.markActivityAsRead(activity.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'No activity yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'When people interact with your threads, you\'ll see it here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AppProvider>().clearError();
                context.read<AppProvider>().loadActivities(refresh: true);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleActivityTap(activity) {
    // Mark as read when tapped
    if (!activity.isRead) {
      context.read<AppProvider>().markActivityAsRead(activity.id);
    }

    // Navigate based on activity type
    if (activity.isThreadAction && activity.thread != null) {
      _navigateToThread(activity.thread.id);
    } else if (activity.isFollowAction) {
      _navigateToUserProfile(activity.actor.id);
    }
  }

  void _navigateToThread(String threadId) {
    // TODO: Navigate to thread detail
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thread detail navigation coming soon!')),
    );
  }

  void _navigateToUserProfile(String userId) {
    // TODO: Navigate to user profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User profile navigation coming soon!')),
    );
  }

  void _markAllAsRead() {
    // TODO: Implement mark all as read
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mark all as read feature coming soon!')),
    );
  }
}