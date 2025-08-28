import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/song.dart';
import '../../../shared/models/playlist.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Good evening',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textPrimaryDark,
                onPressed: () {
                  // TODO: Implement notifications
                },
              ),
              IconButton(
                icon: const Icon(Icons.history),
                color: AppColors.textPrimaryDark,
                onPressed: () {
                  // TODO: Implement history
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                color: AppColors.textPrimaryDark,
                onPressed: () {
                  // TODO: Implement settings
                },
              ),
            ],
          ),

          // Quick Picks Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick picks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickPicksGrid(),
                ],
              ),
            ),
          ),

          // Recently Played Section
          SliverToBoxAdapter(
            child: _buildHorizontalSection(
              title: 'Recently played',
              items: _getMockRecentlyPlayed(),
            ),
          ),

          // Your Mix Section
          SliverToBoxAdapter(
            child: _buildHorizontalSection(
              title: 'Made for you',
              items: _getMockMadeForYou(),
            ),
          ),

          // New Releases Section
          SliverToBoxAdapter(
            child: _buildHorizontalSection(
              title: 'New releases',
              items: _getMockNewReleases(),
            ),
          ),

          // Trending Section
          SliverToBoxAdapter(
            child: _buildHorizontalSection(
              title: 'Trending',
              items: _getMockTrending(),
            ),
          ),

          // Bottom padding for mini player
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPicksGrid() {
    final quickPicks = _getMockQuickPicks();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: quickPicks.length,
      itemBuilder: (context, index) {
        final item = quickPicks[index];
        return _buildQuickPickItem(item);
      },
    );
  }

  Widget _buildQuickPickItem(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // TODO: Handle quick pick tap
          },
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSection({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildHorizontalItem(item);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHorizontalItem(Map<String, dynamic> item) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.cardDark,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  // TODO: Handle item tap
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                      item['icon'] as IconData,
                      color: AppColors.textPrimaryDark,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['title'] as String,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Mock data methods
  List<Map<String, dynamic>> _getMockQuickPicks() {
    return [
      {'title': 'Liked Music', 'icon': Icons.favorite},
      {'title': 'Downloaded', 'icon': Icons.download_done},
      {'title': 'Your Mix', 'icon': Icons.shuffle},
      {'title': 'Discover Mix', 'icon': Icons.explore},
      {'title': 'New Release Mix', 'icon': Icons.new_releases},
      {'title': 'Recently Played', 'icon': Icons.history},
    ];
  }

  List<Map<String, dynamic>> _getMockRecentlyPlayed() {
    return [
      {'title': 'Pop Mix', 'icon': Icons.music_note},
      {'title': 'Rock Classics', 'icon': Icons.music_note},
      {'title': 'Chill Vibes', 'icon': Icons.music_note},
      {'title': 'Workout Hits', 'icon': Icons.music_note},
      {'title': 'Study Focus', 'icon': Icons.music_note},
    ];
  }

  List<Map<String, dynamic>> _getMockMadeForYou() {
    return [
      {'title': 'Discover Weekly', 'icon': Icons.auto_awesome},
      {'title': 'Release Radar', 'icon': Icons.radar},
      {'title': 'Daily Mix 1', 'icon': Icons.playlist_play},
      {'title': 'Daily Mix 2', 'icon': Icons.playlist_play},
      {'title': 'Daily Mix 3', 'icon': Icons.playlist_play},
    ];
  }

  List<Map<String, dynamic>> _getMockNewReleases() {
    return [
      {'title': 'New Album 1', 'icon': Icons.album},
      {'title': 'New Album 2', 'icon': Icons.album},
      {'title': 'New Single 1', 'icon': Icons.music_note},
      {'title': 'New Single 2', 'icon': Icons.music_note},
      {'title': 'New EP', 'icon': Icons.album},
    ];
  }

  List<Map<String, dynamic>> _getMockTrending() {
    return [
      {'title': 'Viral Hits', 'icon': Icons.trending_up},
      {'title': 'Top 50 Global', 'icon': Icons.public},
      {'title': 'Top 50 Local', 'icon': Icons.location_on},
      {'title': 'Rising Artists', 'icon': Icons.star},
      {'title': 'Trending Videos', 'icon': Icons.video_library},
    ];
  }
}