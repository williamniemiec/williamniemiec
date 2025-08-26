import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample user data
  final Map<String, dynamic> _currentUser = {
    'id': 'user_123',
    'username': 'john_doe',
    'displayName': 'John Doe',
    'bio': 'Passionate about design, travel, and good food 🎨✈️🍕',
    'profileImage': 'https://picsum.photos/150/150?random=user',
    'followersCount': 1234,
    'followingCount': 567,
    'pinsCount': 89,
    'boardsCount': 12,
    'isVerified': true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: _currentUser['username'],
        actions: [
          IconButton(
            onPressed: _showMoreOptions,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: _buildProfileHeader(),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondary,
                  indicatorColor: AppTheme.primaryColor,
                  labelStyle: const TextStyle(
                    fontSize: AppTheme.fontSizeMedium,
                    fontWeight: AppTheme.fontWeightSemiBold,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: AppTheme.fontSizeMedium,
                    fontWeight: AppTheme.fontWeightRegular,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  tabs: const [
                    Tab(text: 'Created'),
                    Tab(text: 'Saved'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCreatedTab(),
            _buildSavedTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        children: [
          // Profile Image
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.grey300,
                backgroundImage: NetworkImage(_currentUser['profileImage']),
              ),
              if (_currentUser['isVerified'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          
          // Display Name
          Text(
            _currentUser['displayName'],
            style: const TextStyle(
              fontSize: AppTheme.fontSizeXXLarge,
              fontWeight: AppTheme.fontWeightBold,
              color: AppTheme.textPrimary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          
          // Username
          Text(
            '@${_currentUser['username']}',
            style: const TextStyle(
              fontSize: AppTheme.fontSizeMedium,
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          
          // Bio
          if (_currentUser['bio'] != null)
            Text(
              _currentUser['bio'],
              style: const TextStyle(
                fontSize: AppTheme.fontSizeMedium,
                color: AppTheme.textPrimary,
                fontFamily: AppTheme.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Followers',
                _formatCount(_currentUser['followersCount']),
                () => _showFollowers(),
              ),
              _buildStatItem(
                'Following',
                _formatCount(_currentUser['followingCount']),
                () => _showFollowing(),
              ),
              _buildStatItem(
                'Pins',
                _formatCount(_currentUser['pinsCount']),
                null,
              ),
              _buildStatItem(
                'Boards',
                _formatCount(_currentUser['boardsCount']),
                null,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _editProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.grey200,
                    foregroundColor: AppTheme.textPrimary,
                    elevation: 0,
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              Expanded(
                child: ElevatedButton(
                  onPressed: _shareProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.grey200,
                    foregroundColor: AppTheme.textPrimary,
                    elevation: 0,
                  ),
                  child: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: AppTheme.fontSizeXLarge,
              fontWeight: AppTheme.fontWeightBold,
              color: AppTheme.textPrimary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTheme.fontSizeSmall,
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.push_pin_outlined,
            size: 64,
            color: AppTheme.grey400,
          ),
          SizedBox(height: AppTheme.spacingMedium),
          Text(
            'No pins created yet',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLarge,
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          SizedBox(height: AppTheme.spacingSmall),
          Text(
            'Create your first pin to get started',
            style: TextStyle(
              fontSize: AppTheme.fontSizeMedium,
              color: AppTheme.textTertiary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_outlined,
            size: 64,
            color: AppTheme.grey400,
          ),
          SizedBox(height: AppTheme.spacingMedium),
          Text(
            'No boards created yet',
            style: TextStyle(
              fontSize: AppTheme.fontSizeLarge,
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
          SizedBox(height: AppTheme.spacingSmall),
          Text(
            'Create boards to organize your pins',
            style: TextStyle(
              fontSize: AppTheme.fontSizeMedium,
              color: AppTheme.textTertiary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _openSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                _openHelp();
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
            const SizedBox(height: AppTheme.spacingMedium),
          ],
        ),
      ),
    );
  }

  void _showFollowers() {
    Navigator.pushNamed(context, '/followers');
  }

  void _showFollowing() {
    Navigator.pushNamed(context, '/following');
  }

  void _editProfile() {
    Navigator.pushNamed(context, '/edit_profile');
  }

  void _shareProfile() {
    // Implement share profile functionality
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _openHelp() {
    Navigator.pushNamed(context, '/help');
  }

  void _signOut() {
    // Implement sign out functionality
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}