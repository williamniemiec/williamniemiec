import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/video.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

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
  late User _currentUser;
  List<Video> _userVideos = [];
  List<Video> _likedVideos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Mock user data
    _currentUser = User(
      id: widget.userId ?? 'current_user',
      username: 'your_username',
      displayName: 'Your Display Name',
      email: 'user@example.com',
      profileImageUrl: AppConstants.placeholderProfileImage,
      bio: '✨ Content Creator\n🎵 Music Lover\n📍 New York',
      followersCount: 12500,
      followingCount: 850,
      likesCount: 125000,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Mock user videos
    _userVideos = List.generate(12, (index) => Video(
      id: 'user_video_$index',
      videoUrl: AppConstants.placeholderVideoUrl,
      thumbnailUrl: AppConstants.placeholderImageUrl,
      caption: 'My video #${index + 1}',
      creator: _currentUser,
      duration: 30,
      likesCount: (index + 1) * 50,
      commentsCount: (index + 1) * 10,
      sharesCount: (index + 1) * 5,
      viewsCount: (index + 1) * 500,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));

    // Mock liked videos
    _likedVideos = List.generate(8, (index) => Video(
      id: 'liked_video_$index',
      videoUrl: AppConstants.placeholderVideoUrl,
      thumbnailUrl: AppConstants.placeholderImageUrl,
      caption: 'Liked video #${index + 1}',
      creator: User(
        id: 'other_user_$index',
        username: 'creator_$index',
        displayName: 'Creator $index',
        email: 'creator$index@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      duration: 30,
      likesCount: (index + 1) * 100,
      commentsCount: (index + 1) * 20,
      sharesCount: (index + 1) * 10,
      viewsCount: (index + 1) * 1000,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentUser.username,
                    style: AppTheme.usernameStyle,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Open notifications
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppConstants.iconColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Open menu
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: AppConstants.iconColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Profile Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Info
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        children: [
                          // Profile Picture
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstants.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: _currentUser.profileImageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: _currentUser.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: AppConstants.surfaceColor,
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: AppConstants.textSecondaryColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: AppConstants.surfaceColor,
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: AppConstants.textSecondaryColor,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: AppConstants.surfaceColor,
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppConstants.textSecondaryColor,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: AppConstants.defaultPadding),

                          // Display Name and Verification
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentUser.displayName,
                                style: const TextStyle(
                                  color: AppConstants.textPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_currentUser.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: AppConstants.secondaryColor,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: AppConstants.smallPadding),

                          // Bio
                          if (_currentUser.bio != null)
                            Text(
                              _currentUser.bio!,
                              style: const TextStyle(
                                color: AppConstants.textSecondaryColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          const SizedBox(height: AppConstants.defaultPadding),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                'Following',
                                _formatCount(_currentUser.followingCount),
                              ),
                              _buildStatItem(
                                'Followers',
                                _formatCount(_currentUser.followersCount),
                              ),
                              _buildStatItem(
                                'Likes',
                                _formatCount(_currentUser.likesCount),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppConstants.defaultPadding),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Edit profile
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.surfaceColor,
                                    foregroundColor: AppConstants.textPrimaryColor,
                                  ),
                                  child: const Text('Edit profile'),
                                ),
                              ),
                              const SizedBox(width: AppConstants.smallPadding),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Share profile
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.surfaceColor,
                                  foregroundColor: AppConstants.textPrimaryColor,
                                  minimumSize: const Size(50, 36),
                                ),
                                child: const Icon(Icons.share),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tab Bar
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppConstants.dividerColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: AppConstants.primaryColor,
                        labelColor: AppConstants.textPrimaryColor,
                        unselectedLabelColor: AppConstants.textSecondaryColor,
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.grid_on),
                            text: 'Videos',
                          ),
                          Tab(
                            icon: Icon(Icons.favorite_border),
                            text: 'Liked',
                          ),
                        ],
                      ),
                    ),

                    // Tab Content
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildVideoGrid(_userVideos),
                          _buildVideoGrid(_likedVideos),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: AppConstants.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoGrid(List<Video> videos) {
    if (videos.isEmpty) {
      return const Center(
        child: Text(
          'No videos yet',
          style: TextStyle(
            color: AppConstants.textSecondaryColor,
            fontSize: 16,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to video player
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                // Video Thumbnail
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: video.thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: video.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppConstants.surfaceColor,
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppConstants.surfaceColor,
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                  ),
                ),

                // View Count
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(video.viewsCount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}