import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class MyNetflixScreen extends StatefulWidget {
  const MyNetflixScreen({super.key});

  @override
  State<MyNetflixScreen> createState() => _MyNetflixScreenState();
}

class _MyNetflixScreenState extends State<MyNetflixScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myNetflix,
          style: TextStyle(
            color: AppTheme.netflixWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.netflixBlack,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {
              // TODO: Implement casting
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show more options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
            
            const SizedBox(height: 24),
            
            // Downloads Section
            _buildDownloadsSection(),
            
            const SizedBox(height: 24),
            
            // My List Section
            _buildMyListSection(),
            
            const SizedBox(height: 24),
            
            // Continue Watching Section
            _buildContinueWatchingSection(),
            
            const SizedBox(height: 24),
            
            // Settings and More
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.netflixRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person,
              color: AppTheme.netflixWhite,
              size: 40,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: AppTheme.netflixWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Switch Profiles',
                  style: TextStyle(
                    color: AppTheme.netflixLightGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Manage profiles
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.netflixRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    AppStrings.manageProfiles,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {
              // TODO: Show notifications
            },
          ),
          _buildQuickActionButton(
            icon: Icons.download_outlined,
            label: AppStrings.downloads,
            onTap: () {
              // TODO: Show downloads
            },
          ),
          _buildQuickActionButton(
            icon: Icons.history,
            label: 'History',
            onTap: () {
              // TODO: Show viewing history
            },
          ),
          _buildQuickActionButton(
            icon: Icons.settings_outlined,
            label: AppStrings.settings,
            onTap: () {
              // TODO: Show settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.netflixDarkGray,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: AppTheme.netflixWhite,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.netflixLightGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.downloads,
                style: NetflixTextStyles.sectionTitle,
              ),
              TextButton(
                onPressed: () {
                  // TODO: See all downloads
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: AppTheme.netflixLightGray),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                height: 120,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppTheme.netflixDarkGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_done,
                      color: AppTheme.netflixWhite,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Content ${index + 1}',
                      style: const TextStyle(
                        color: AppTheme.netflixWhite,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.myList,
                style: NetflixTextStyles.sectionTitle,
              ),
              TextButton(
                onPressed: () {
                  // TODO: See all in My List
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: AppTheme.netflixLightGray),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                height: 120,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppTheme.netflixDarkGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppTheme.netflixRed,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Title ${index + 1}',
                      style: const TextStyle(
                        color: AppTheme.netflixWhite,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContinueWatchingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: Text(
            'Continue Watching',
            style: NetflixTextStyles.sectionTitle,
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                height: 120,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppTheme.netflixDarkGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    // Progress indicator
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.netflixLightGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (index + 1) * 0.15,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.netflixRed,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Play button
                    const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: AppTheme.netflixWhite,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.account_circle_outlined,
            title: AppStrings.account,
            onTap: () {
              // TODO: Show account settings
            },
          ),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: AppStrings.help,
            onTap: () {
              // TODO: Show help
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: AppStrings.signOut,
            onTap: () {
              // TODO: Sign out
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.netflixWhite,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.netflixWhite,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.netflixLightGray,
      ),
      onTap: onTap,
    );
  }
}