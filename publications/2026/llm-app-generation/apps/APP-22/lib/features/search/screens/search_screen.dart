import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/models.dart';
import '../providers/search_provider.dart';
import '../../player/providers/player_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'What do you want to listen to?',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchProvider>().clearResults();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onChanged: (query) {
                  context.read<SearchProvider>().search(query);
                  setState(() {});
                },
              ),
            ),

            // Content
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  if (searchProvider.query.isEmpty) {
                    return _buildBrowseCategories();
                  }

                  if (searchProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (!searchProvider.hasResults) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching for something else',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildSearchResults(searchProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse all',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryCard(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        _searchController.text = category['name'];
        context.read<SearchProvider>().search(category['name']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: category['color'],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                category['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: -10,
              child: Transform.rotate(
                angle: 0.3,
                child: Icon(
                  category['icon'],
                  size: 60,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchProvider searchProvider) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.lightGrey,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Songs'),
              Tab(text: 'Albums'),
              Tab(text: 'Artists'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAllResults(searchProvider),
                _buildTrackResults(searchProvider.trackResults),
                _buildAlbumResults(searchProvider.albumResults),
                _buildArtistResults(searchProvider.artistResults),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllResults(SearchProvider searchProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchProvider.trackResults.isNotEmpty) ...[
            Text(
              'Songs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...searchProvider.trackResults.take(3).map(
              (track) => _buildTrackTile(track),
            ),
            const SizedBox(height: 24),
          ],
          if (searchProvider.albumResults.isNotEmpty) ...[
            Text(
              'Albums',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searchProvider.albumResults.length,
                itemBuilder: (context, index) {
                  final album = searchProvider.albumResults[index];
                  return _buildAlbumCard(album);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (searchProvider.artistResults.isNotEmpty) ...[
            Text(
              'Artists',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searchProvider.artistResults.length,
                itemBuilder: (context, index) {
                  final artist = searchProvider.artistResults[index];
                  return _buildArtistCard(artist);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackResults(List<Track> tracks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        return _buildTrackTile(tracks[index]);
      },
    );
  }

  Widget _buildAlbumResults(List<Album> albums) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return _buildAlbumCard(albums[index]);
      },
    );
  }

  Widget _buildArtistResults(List<Artist> artists) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return _buildArtistCard(artists[index]);
      },
    );
  }

  Widget _buildTrackTile(Track track) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: CachedNetworkImageProvider(track.albumArt),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        track.title,
        style: const TextStyle(
          color: AppColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist,
        style: const TextStyle(
          color: AppColors.lightGrey,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          // TODO: Show more options
        },
        icon: const Icon(
          Icons.more_vert,
          color: AppColors.lightGrey,
        ),
      ),
      onTap: () {
        context.read<PlayerProvider>().playTrack(track);
      },
    );
  }

  Widget _buildAlbumCard(Album album) {
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
              image: DecorationImage(
                image: CachedNetworkImageProvider(album.coverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            album.title,
            style: const TextStyle(
              color: AppColors.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            album.artistName,
            style: const TextStyle(
              color: AppColors.lightGrey,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildArtistCard(Artist artist) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(artist.profileImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artist.name,
            style: const TextStyle(
              color: AppColors.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            'Artist',
            style: const TextStyle(
              color: AppColors.lightGrey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Pop',
      'color': const Color(0xFFFF6B6B),
      'icon': Icons.music_note,
    },
    {
      'name': 'Hip-Hop',
      'color': const Color(0xFF4ECDC4),
      'icon': Icons.headphones,
    },
    {
      'name': 'Rock',
      'color': const Color(0xFF45B7D1),
      'icon': Icons.music_note,
    },
    {
      'name': 'Electronic',
      'color': const Color(0xFF96CEB4),
      'icon': Icons.equalizer,
    },
    {
      'name': 'Jazz',
      'color': const Color(0xFFFECEA8),
      'icon': Icons.piano,
    },
    {
      'name': 'Classical',
      'color': const Color(0xFFD63031),
      'icon': Icons.library_music,
    },
    {
      'name': 'Podcasts',
      'color': const Color(0xFF6C5CE7),
      'icon': Icons.mic,
    },
    {
      'name': 'Workout',
      'color': const Color(0xFFA29BFE),
      'icon': Icons.fitness_center,
    },
  ];
}