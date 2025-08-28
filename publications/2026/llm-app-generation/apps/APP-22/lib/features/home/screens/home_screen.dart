import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/models.dart';
import '../providers/home_provider.dart';
import '../../player/providers/player_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            if (homeProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (homeProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => homeProvider.loadHomeData(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    AppConstants.getGreeting(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // TODO: Implement notifications
                      },
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Implement settings
                      },
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),

                // Recently Played
                if (homeProvider.recentlyPlayed.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Recently played',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeProvider.recentlyPlayed.length,
                        itemBuilder: (context, index) {
                          final playlist = homeProvider.recentlyPlayed[index];
                          return _buildPlaylistCard(context, playlist);
                        },
                      ),
                    ),
                  ),
                ],

                // Made For You
                if (homeProvider.madeForYou.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Made for you',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeProvider.madeForYou.length,
                        itemBuilder: (context, index) {
                          final playlist = homeProvider.madeForYou[index];
                          return _buildPlaylistCard(context, playlist);
                        },
                      ),
                    ),
                  ),
                ],

                // New Releases
                if (homeProvider.newReleases.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'New releases for you',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final track = homeProvider.newReleases[index];
                        return _buildTrackTile(context, track);
                      },
                      childCount: homeProvider.newReleases.length,
                    ),
                  ),
                ],

                // Featured Albums
                if (homeProvider.featuredAlbums.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Featured albums',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeProvider.featuredAlbums.length,
                        itemBuilder: (context, index) {
                          final album = homeProvider.featuredAlbums[index];
                          return _buildAlbumCard(context, album);
                        },
                      ),
                    ),
                  ),
                ],

                // Bottom padding for mini player
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, Playlist playlist) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Navigate to playlist detail
            },
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(playlist.coverImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: playlist.coverImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.grey.withOpacity(0.3),
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.grey,
                    size: 40,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.grey.withOpacity(0.3),
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playlist.name,
            style: const TextStyle(
              color: AppColors.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(BuildContext context, Album album) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Navigate to album detail
            },
            child: Container(
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

  Widget _buildTrackTile(BuildContext context, Track track) {
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
}