import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                  'Explore',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'New releases'),
                    Tab(text: 'Charts'),
                    Tab(text: 'Moods & genres'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNewReleasesTab(),
            _buildChartsTab(),
            _buildMoodsGenresTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewReleasesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('New albums & singles'),
          const SizedBox(height: 16),
          _buildNewReleasesGrid(),
          const SizedBox(height: 32),
          _buildSectionTitle('New music videos'),
          const SizedBox(height: 16),
          _buildMusicVideosGrid(),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Top songs'),
          const SizedBox(height: 16),
          _buildTopSongsList(),
          const SizedBox(height: 32),
          _buildSectionTitle('Top artists'),
          const SizedBox(height: 16),
          _buildTopArtistsList(),
          const SizedBox(height: 32),
          _buildSectionTitle('Trending'),
          const SizedBox(height: 16),
          _buildTrendingList(),
        ],
      ),
    );
  }

  Widget _buildMoodsGenresTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Browse by mood'),
          const SizedBox(height: 16),
          _buildMoodsGrid(),
          const SizedBox(height: 32),
          _buildSectionTitle('Browse by genre'),
          const SizedBox(height: 16),
          _buildGenresGrid(),
        ],
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

  Widget _buildNewReleasesGrid() {
    final releases = _getMockNewReleases();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final release = releases[index];
        return _buildReleaseCard(release);
      },
    );
  }

  Widget _buildMusicVideosGrid() {
    final videos = _getMockMusicVideos();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 16,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildTopSongsList() {
    final songs = _getMockTopSongs();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return _buildSongListItem(song, index + 1);
      },
    );
  }

  Widget _buildTopArtistsList() {
    final artists = _getMockTopArtists();
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return _buildArtistCard(artist);
        },
      ),
    );
  }

  Widget _buildTrendingList() {
    final trending = _getMockTrending();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trending.length,
      itemBuilder: (context, index) {
        final item = trending[index];
        return _buildTrendingItem(item);
      },
    );
  }

  Widget _buildMoodsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: AppConstants.moodCategories.length,
      itemBuilder: (context, index) {
        final mood = AppConstants.moodCategories[index];
        return _buildMoodCard(mood, AppColors.moodColors[mood] ?? AppColors.primary);
      },
    );
  }

  Widget _buildGenresGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: AppConstants.musicCategories.length,
      itemBuilder: (context, index) {
        final genre = AppConstants.musicCategories[index];
        return _buildGenreCard(genre, AppColors.genreColors[genre] ?? AppColors.secondary);
      },
    );
  }

  Widget _buildReleaseCard(Map<String, dynamic> release) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to release details
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.secondary.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.album,
                      color: AppColors.textPrimaryDark,
                      size: 48,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      release['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      release['artist'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Play video
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.secondary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: AppColors.textPrimaryDark,
                  size: 64,
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      video['artist'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongListItem(Map<String, dynamic> song, int rank) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            rank.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        song['title'] as String,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        song['artist'] as String,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.textSecondaryDark,
        onPressed: () {
          // TODO: Show song options
        },
      ),
      onTap: () {
        // TODO: Play song
      },
    );
  }

  Widget _buildArtistCard(Map<String, dynamic> artist) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.textSecondaryDark,
              size: 48,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artist['name'] as String,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingItem(Map<String, dynamic> item) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          item['icon'] as IconData,
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
        item['subtitle'] as String,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: const Icon(
        Icons.trending_up,
        color: AppColors.accent,
      ),
      onTap: () {
        // TODO: Navigate to trending item
      },
    );
  }

  Widget _buildMoodCard(String mood, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to mood playlist
          },
          child: Center(
            child: Text(
              mood,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(String genre, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to genre playlist
          },
          child: Center(
            child: Text(
              genre,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mock data methods
  List<Map<String, dynamic>> _getMockNewReleases() {
    return [
      {'title': 'New Album 1', 'artist': 'Artist 1'},
      {'title': 'New Album 2', 'artist': 'Artist 2'},
      {'title': 'New Single 1', 'artist': 'Artist 3'},
      {'title': 'New Single 2', 'artist': 'Artist 4'},
      {'title': 'New EP', 'artist': 'Artist 5'},
      {'title': 'Latest Release', 'artist': 'Artist 6'},
    ];
  }

  List<Map<String, dynamic>> _getMockMusicVideos() {
    return [
      {'title': 'Music Video 1', 'artist': 'Artist 1'},
      {'title': 'Music Video 2', 'artist': 'Artist 2'},
      {'title': 'Music Video 3', 'artist': 'Artist 3'},
    ];
  }

  List<Map<String, dynamic>> _getMockTopSongs() {
    return [
      {'title': 'Top Song 1', 'artist': 'Artist 1'},
      {'title': 'Top Song 2', 'artist': 'Artist 2'},
      {'title': 'Top Song 3', 'artist': 'Artist 3'},
      {'title': 'Top Song 4', 'artist': 'Artist 4'},
      {'title': 'Top Song 5', 'artist': 'Artist 5'},
    ];
  }

  List<Map<String, dynamic>> _getMockTopArtists() {
    return [
      {'name': 'Top Artist 1'},
      {'name': 'Top Artist 2'},
      {'name': 'Top Artist 3'},
      {'name': 'Top Artist 4'},
      {'name': 'Top Artist 5'},
    ];
  }

  List<Map<String, dynamic>> _getMockTrending() {
    return [
      {'title': 'Viral Hit 1', 'subtitle': 'Trending now', 'icon': Icons.trending_up},
      {'title': 'Popular Song', 'subtitle': 'Rising fast', 'icon': Icons.whatshot},
      {'title': 'New Trend', 'subtitle': 'Just discovered', 'icon': Icons.new_releases},
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