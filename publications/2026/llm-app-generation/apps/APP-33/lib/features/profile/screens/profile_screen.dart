import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../home/widgets/thread_item.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; // If null, shows current user's profile

  const ProfileScreen({
    super.key,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final user = widget.userId == null 
              ? appProvider.currentUser 
              : null; // TODO: Get user by ID

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar with user info
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                actions: [
                  if (widget.userId == null) // Current user's profile
                    IconButton(
                      onPressed: _showProfileMenu,
                      icon: const Icon(Icons.more_horiz),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Profile picture
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              child: user.profileImageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        imageUrl: user.profileImageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: Theme.of(context).colorScheme.surface,
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Theme.of(context).textTheme.bodySmall?.color,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: Theme.of(context).colorScheme.surface,
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Theme.of(context).textTheme.bodySmall?.color,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                            ),
                            const Spacer(),
                            
                            // Follow/Edit button
                            if (widget.userId == null)
                              OutlinedButton(
                                onPressed: _editProfile,
                                child: const Text('Edit profile'),
                              )
                            else
                              ElevatedButton(
                                onPressed: _toggleFollow,
                                child: const Text('Follow'), // TODO: Dynamic text
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // User info
                        Row(
                          children: [
                            Text(
                              user.displayName,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.isVerified) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.verified,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${user.username}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        if (user.bio != null && user.bio!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            user.bio!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                        const SizedBox(height: 12),
                        
                        // Stats
                        Row(
                          children: [
                            _buildStatItem(
                              context,
                              '${_formatCount(user.followersCount)}',
                              'followers',
                              onTap: _showFollowers,
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              context,
                              '${_formatCount(user.followingCount)}',
                              'following',
                              onTap: _showFollowing,
                            ),
                          ],
                        ),
                        
                        // Instagram link
                        if (user.instagramUsername != null) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _openInstagram,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 16,
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '@${user.instagramUsername}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 2,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                  labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Threads'),
                    Tab(text: 'Replies'),
                  ],
                ),
              ),
              
              // Tab content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildThreadsTab(appProvider),
                    _buildRepliesTab(appProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String count,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: count,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: ' $label',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreadsTab(AppProvider appProvider) {
    // TODO: Load user's threads
    return _buildEmptyState(
      'No threads yet',
      'When you post threads, they\'ll appear here.',
    );
  }

  Widget _buildRepliesTab(AppProvider appProvider) {
    // TODO: Load user's replies
    return _buildEmptyState(
      'No replies yet',
      'When you reply to threads, they\'ll appear here.',
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

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _showSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.pop(context);
                _signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    // TODO: Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon!')),
    );
  }

  void _toggleFollow() {
    // TODO: Implement follow/unfollow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Follow feature coming soon!')),
    );
  }

  void _showFollowers() {
    // TODO: Navigate to followers screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Followers screen coming soon!')),
    );
  }

  void _showFollowing() {
    // TODO: Navigate to following screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Following screen coming soon!')),
    );
  }

  void _openInstagram() {
    // TODO: Open Instagram profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instagram integration coming soon!')),
    );
  }

  void _showSettings() {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings screen coming soon!')),
    );
  }

  void _signOut() {
    context.read<AppProvider>().signOut();
  }
}