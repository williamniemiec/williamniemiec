import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

// Provider for library tab index
final libraryTabProvider = StateProvider<int>((ref) => 0);

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      ref.read(libraryTabProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Your Library',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  color: AppColors.textPrimaryDark,
                  onPressed: () {
                    // TODO: Search in library
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  color: AppColors.textPrimaryDark,
                  onPressed: () {
                    // TODO: Sort options
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.cardDark,
                  onSelected: (value) {
                    // TODO: Handle menu selection
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'grid',
                      child: Row(
                        children: [
                          Icon(Icons.grid_view, color: AppColors.textPrimaryDark),
                          const SizedBox(width: 12),
                          Text('Grid view', style: TextStyle(color: AppColors.textPrimaryDark)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'list',
                      child: Row(
                        children: [
                          Icon(Icons.list, color: AppColors.textPrimaryDark),
                          const SizedBox(width: 12),
                          Text('List view', style: TextStyle(color: AppColors.textPrimaryDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Recently played'),
                    Tab(text: 'Playlists'),
                    Tab(text: 'Artists'),
                    Tab(text: 'Albums'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRecentlyPlayedTab(),
            _buildPlaylistsTab(),
            _buildArtistsTab(),
            _buildAlbumsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Access
          _buildQuickAccessSection(),
          const SizedBox(height: 32),
          
          // Recently Played Songs
          _buildSectionTitle('Recently played'),
          const SizedBox(height: 16),
          _buildRecentlyPlayedList(),
        ],
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create Playlist Button
          _buildCreatePlaylistButton(),
          const SizedBox(height: 24),
          
          // Default Playlists
          _buildSectionTitle('Made by YouTube Music'),
          const SizedBox(height: 16),
          _buildDefaultPlaylistsList(),
          const SizedBox(height: 32),
          
          // User Playlists
          _buildSectionTitle('Created by you'),
          const SizedBox(height: 16),
          _buildUserPlaylistsList(),
        ],
      ),
    );
  }

  Widget _buildArtistsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Artists you follow'),
          const SizedBox(height: 16),
          _buildFollowedArtistsList(),
        ],
      ),
    );
  }

  Widget _buildAlbumsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Albums you saved'),
          const SizedBox(height: 16),
          _buildSavedAlbumsList(),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    final quickAccessItems = [
      {'title': 'Liked Music', 'icon': Icons.favorite, 'color': AppColors.accent},
      {'title': 'Downloaded', 'icon': Icons.download_done, 'color': AppColors.accentBlue},
      {'title': 'History', 'icon': Icons.history, 'color': AppColors.accentPurple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick picks'),
        const SizedBox(height: 16),
        ...quickAccessItems.map((item) => _buildQuickAccessItem(item)),
      ],
    );
  }

  Widget _buildQuickAccessItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // TODO: Navigate to quick access item
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondaryDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatePlaylistButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Create new playlist
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Create playlist',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: AppColors.textPrimaryDark,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRecentlyPlayedList() {
    final recentlyPlayed = _getMockRecentlyPlayed();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentlyPlayed.length,
      itemBuilder: (context, index) {
        final item = recentlyPlayed[index];
        return _buildMusicListItem(item);
      },
    );
  }

  Widget _buildDefaultPlaylistsList() {
    final defaultPlaylists = _getMockDefaultPlaylists();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: defaultPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = defaultPlaylists[index];
        return _buildPlaylistListItem(playlist);
      },
    );
  }

  Widget _buildUserPlaylistsList() {
    final userPlaylists = _getMockUserPlaylists();
    return userPlaylists.isEmpty
        ? _buildEmptyState(
            icon: Icons.playlist_add,
            title: 'No playlists yet',
            subtitle: 'Create your first playlist',
            actionText: 'Create playlist',
            onAction: () {
              // TODO: Create playlist
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userPlaylists.length,
            itemBuilder: (context, index) {
              final playlist = userPlaylists[index];
              return _buildPlaylistListItem(playlist);
            },
          );
  }

  Widget _buildFollowedArtistsList() {
    final followedArtists = _getMockFollowedArtists();
    return followedArtists.isEmpty
        ? _buildEmptyState(
            icon: Icons.person_add,
            title: 'No artists followed',
            subtitle: 'Follow artists to see them here',
            actionText: 'Explore artists',
            onAction: () {
              // TODO: Navigate to explore
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: followedArtists.length,
            itemBuilder: (context, index) {
              final artist = followedArtists[index];
              return _buildArtistListItem(artist);
            },
          );
  }

  Widget _buildSavedAlbumsList() {
    final savedAlbums = _getMockSavedAlbums();
    return savedAlbums.isEmpty
        ? _buildEmptyState(
            icon: Icons.album,
            title: 'No albums saved',
            subtitle: 'Save albums to see them here',
            actionText: 'Explore albums',
            onAction: () {
              // TODO: Navigate to explore
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: savedAlbums.length,
            itemBuilder: (context, index) {
              final album = savedAlbums[index];
              return _buildAlbumListItem(album);
            },
          );
  }

  Widget _buildMusicListItem(Map<String, dynamic> item) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.music_note,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        item['title'] as String,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        item['artist'] as String,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.textSecondaryDark,
        onPressed: () {
          // TODO: Show options
        },
      ),
      onTap: () {
        // TODO: Play song
      },
    );
  }

  Widget _buildPlaylistListItem(Map<String, dynamic> playlist) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.playlist_play,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        playlist['name'] as String,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        '${playlist['songCount']} songs',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.textSecondaryDark,
        onPressed: () {
          // TODO: Show playlist options
        },
      ),
      onTap: () {
        // TODO: Open playlist
      },
    );
  }

  Widget _buildArtistListItem(Map<String, dynamic> artist) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        artist['name'] as String,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        'Artist',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.textSecondaryDark,
        onPressed: () {
          // TODO: Show artist options
        },
      ),
      onTap: () {
        // TODO: Open artist page
      },
    );
  }

  Widget _buildAlbumListItem(Map<String, dynamic> album) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.album,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        album['title'] as String,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        album['artist'] as String,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.textSecondaryDark,
        onPressed: () {
          // TODO: Show album options
        },
      ),
      onTap: () {
        // TODO: Open album
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textTertiaryDark,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  // Mock data methods
  List<Map<String, dynamic>> _getMockRecentlyPlayed() {
    return [
      {'title': 'Song 1', 'artist': 'Artist 1'},
      {'title': 'Song 2', 'artist': 'Artist 2'},
      {'title': 'Song 3', 'artist': 'Artist 3'},
      {'title': 'Song 4', 'artist': 'Artist 4'},
      {'title': 'Song 5', 'artist': 'Artist 5'},
    ];
  }

  List<Map<String, dynamic>> _getMockDefaultPlaylists() {
    return AppConstants.defaultPlaylistNames.map((name) => {
      'name': name,
      'songCount': 25,
      'isDefault': true,
    }).toList();
  }

  List<Map<String, dynamic>> _getMockUserPlaylists() {
    return [
      {'name': 'My Favorites', 'songCount': 42, 'isDefault': false},
      {'name': 'Road Trip', 'songCount': 18, 'isDefault': false},
      {'name': 'Workout Mix', 'songCount': 35, 'isDefault': false},
    ];
  }

  List<Map<String, dynamic>> _getMockFollowedArtists() {
    return [
      {'name': 'Artist 1'},
      {'name': 'Artist 2'},
      {'name': 'Artist 3'},
    ];
  }

  List<Map<String, dynamic>> _getMockSavedAlbums() {
    return [
      {'title': 'Album 1', 'artist': 'Artist 1'},
      {'title': 'Album 2', 'artist': 'Artist 2'},
      {'title': 'Album 3', 'artist': 'Artist 3'},
    ];
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.backgroundDark,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}