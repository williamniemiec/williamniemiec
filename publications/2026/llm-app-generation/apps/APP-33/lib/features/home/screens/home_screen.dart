import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/thread_item.dart';
import '../widgets/feed_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _forYouScrollController = ScrollController();
  final ScrollController _followingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Add scroll listeners for pagination
    _forYouScrollController.addListener(_onForYouScroll);
    _followingScrollController.addListener(_onFollowingScroll);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      if (appProvider.forYouFeed.isEmpty) {
        appProvider.loadForYouFeed(refresh: true);
      }
    });
  }

  void _onForYouScroll() {
    if (_forYouScrollController.position.pixels >=
        _forYouScrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      context.read<AppProvider>().loadForYouFeed();
    }
  }

  void _onFollowingScroll() {
    if (_followingScrollController.position.pixels >=
        _followingScrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      context.read<AppProvider>().loadFollowingFeed();
    }
  }

  Future<void> _onRefresh(bool isForYou) async {
    final appProvider = context.read<AppProvider>();
    if (isForYou) {
      await appProvider.loadForYouFeed(refresh: true);
    } else {
      await appProvider.loadFollowingFeed(refresh: true);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _forYouScrollController.dispose();
    _followingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Threads',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: FeedTabBar(controller: _tabController),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.error != null) {
            return _buildErrorState(appProvider.error!);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildForYouFeed(appProvider),
              _buildFollowingFeed(appProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForYouFeed(AppProvider appProvider) {
    if (appProvider.forYouFeed.isEmpty && appProvider.isLoadingThreads) {
      return _buildLoadingState();
    }

    if (appProvider.forYouFeed.isEmpty) {
      return _buildEmptyState(
        'No threads yet',
        'Follow some users to see their threads in your feed.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => _onRefresh(true),
      child: ListView.builder(
        controller: _forYouScrollController,
        padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
        itemCount: appProvider.forYouFeed.length + (appProvider.isLoadingThreads ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= appProvider.forYouFeed.length) {
            return _buildLoadingIndicator();
          }

          final thread = appProvider.forYouFeed[index];
          return ThreadItem(
            thread: thread,
            onLike: () => appProvider.toggleLike(thread.id),
            onReply: () => _showReplyModal(thread),
            onRepost: () => appProvider.toggleRepost(thread.id),
            onShare: () => _shareThread(thread),
          );
        },
      ),
    );
  }

  Widget _buildFollowingFeed(AppProvider appProvider) {
    if (appProvider.followingFeed.isEmpty && appProvider.isLoadingThreads) {
      return _buildLoadingState();
    }

    if (appProvider.followingFeed.isEmpty) {
      return _buildEmptyState(
        'No threads from people you follow',
        'Start following users to see their threads here.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => _onRefresh(false),
      child: ListView.builder(
        controller: _followingScrollController,
        padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
        itemCount: appProvider.followingFeed.length + (appProvider.isLoadingThreads ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= appProvider.followingFeed.length) {
            return _buildLoadingIndicator();
          }

          final thread = appProvider.followingFeed[index];
          return ThreadItem(
            thread: thread,
            onLike: () => appProvider.toggleLike(thread.id),
            onReply: () => _showReplyModal(thread),
            onRepost: () => appProvider.toggleRepost(thread.id),
            onShare: () => _shareThread(thread),
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

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
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
                context.read<AppProvider>().loadForYouFeed(refresh: true);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyModal(thread) {
    // TODO: Implement reply modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reply feature coming soon!')),
    );
  }

  void _shareThread(thread) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }
}