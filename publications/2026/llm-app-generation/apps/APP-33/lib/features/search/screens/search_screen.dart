import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/user_search_item.dart';
import '../widgets/thread_search_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    final appProvider = context.read<AppProvider>();
    
    if (query.isNotEmpty) {
      appProvider.performUserSearch(query);
      appProvider.performThreadSearch(query);
    } else {
      appProvider.performUserSearch('');
      appProvider.performThreadSearch('');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search Threads',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: _searchController.text.isNotEmpty
            ? TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 2,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Users'),
                  Tab(text: 'Threads'),
                ],
              )
            : null,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (_searchController.text.isEmpty) {
            return _buildEmptyState();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildUsersTab(appProvider),
              _buildThreadsTab(appProvider),
            ],
          );
        },
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
              Icons.search,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Threads',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find users and threads by searching for names, usernames, or content.',
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

  Widget _buildUsersTab(AppProvider appProvider) {
    if (appProvider.searchUsers.isEmpty) {
      return _buildNoResultsState('No users found');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      itemCount: appProvider.searchUsers.length,
      itemBuilder: (context, index) {
        final user = appProvider.searchUsers[index];
        return UserSearchItem(
          user: user,
          onTap: () => _navigateToUserProfile(user.id),
          onFollow: () => appProvider.followUser(user.id),
          onUnfollow: () => appProvider.unfollowUser(user.id),
        );
      },
    );
  }

  Widget _buildThreadsTab(AppProvider appProvider) {
    if (appProvider.searchThreads.isEmpty) {
      return _buildNoResultsState('No threads found');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      itemCount: appProvider.searchThreads.length,
      itemBuilder: (context, index) {
        final thread = appProvider.searchThreads[index];
        return ThreadSearchItem(
          thread: thread,
          onTap: () => _navigateToThread(thread.id),
          onLike: () => appProvider.toggleLike(thread.id),
          onReply: () => _showReplyModal(thread),
          onRepost: () => appProvider.toggleRepost(thread.id),
          onShare: () => _shareThread(thread),
        );
      },
    );
  }

  Widget _buildNoResultsState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for something else.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUserProfile(String userId) {
    // TODO: Navigate to user profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User profile navigation coming soon!')),
    );
  }

  void _navigateToThread(String threadId) {
    // TODO: Navigate to thread detail
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thread detail navigation coming soon!')),
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