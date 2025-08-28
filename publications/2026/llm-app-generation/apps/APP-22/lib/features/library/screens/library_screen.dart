import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../providers/library_provider.dart';
import '../../player/providers/player_provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0; // 0: All, 1: Playlists, 2: Artists, 3: Albums

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadLibraryData();
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'U',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Your Library',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement search in library
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {
                      _showCreatePlaylistDialog();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Recently played', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Playlists', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('Artists', 2),
                  const SizedBox(width: 8),
                  _buildFilterChip('Albums', 3),
                  const SizedBox(width: 8),
                  _buildFilterChip('Downloaded', 4),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Consumer<LibraryProvider>(
                builder: (context, libraryProvider, child) {
                  if (libraryProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (libraryProvider.error != null) {
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
                            onPressed: () => libraryProvider.loadLibraryData(),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildContent(libraryProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(LibraryProvider libraryProvider) {
    switch (_selectedFilter) {
      case 0: // Recently played
        return _buildRecentlyPlayed(libraryProvider);
      case 1: // Playlists
        return _buildPlaylists(libraryProvider.playlists);
      case 2: // Artists
        return _buildArtists(libraryProvider.followedArtists);
      case 3: // Albums
        return _buildAlbums(libraryProvider.savedAlbums);
      case 4: // Downloaded
        return _buildDownloaded(libraryProvider.downloadedTracks);
      default:
        return _buildRecentlyPlayed(libraryProvider);
    }
  }

  Widget _buildRecentlyPlayed(LibraryProvider libraryProvider) {
    final allItems = <dynamic>[
      ...libraryProvider.playlists,
      ...libraryProvider.savedAlbums,
      ...libraryProvider.followedArtists,
    ];

    if (allItems.isEmpty) {
      return _buildEmptyState('No recent activity', 'Start listening to see your recent activity here');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        if (item is Playlist) {
          return _buildPlaylistTile(item);
        } else if (item is Album) {
          return _buildAlbumTile(item);
        } else if (item is Artist) {
          return _buildArtistTile(item);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPlaylists(List<Playlist> playlists) {
    if (playlists.isEmpty) {
      return _buildEmptyState('No playlists yet', 'Create your first playlist to get started');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return _buildPlaylistTile(playlists[index]);
      },
    );
  }

  Widget _buildArtists(List<Artist> artists) {
    if (artists.isEmpty) {
      return _buildEmptyState('No artists followed', 'Follow artists to see them here');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return _buildArtistTile(artists[index]);
      },
    );
  }

  Widget _buildAlbums(List<Album> albums) {
    if (albums.isEmpty) {
      return _buildEmptyState('No albums saved', 'Save albums to see them here');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return _buildAlbumTile(albums[index]);
      },
    );
  }

  Widget _buildDownloaded(List<Track> tracks) {
    if (tracks.isEmpty) {
      return _buildEmptyState('No downloads', 'Download music to listen offline');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        return _buildTrackTile(tracks[index]);
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_outlined,
            size: 64,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(Playlist playlist) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: CachedNetworkImageProvider(playlist.coverImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        playlist.name,
        style: const TextStyle(
          color: AppColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${playlist.trackCount} songs • ${playlist.creatorName}',
        style: const TextStyle(
          color: AppColors.lightGrey,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          _showPlaylistOptions(playlist);
        },
        icon: const Icon(
          Icons.more_vert,
          color: AppColors.lightGrey,
        ),
      ),
      onTap: () {
        // TODO: Navigate to playlist detail
      },
    );
  }

  Widget _buildAlbumTile(Album album) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: CachedNetworkImageProvider(album.coverImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        album.title,
        style: const TextStyle(
          color: AppColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'Album • ${album.artistName}',
        style: const TextStyle(
          color: AppColors.lightGrey,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          _showAlbumOptions(album);
        },
        icon: const Icon(
          Icons.more_vert,
          color: AppColors.lightGrey,
        ),
      ),
      onTap: () {
        // TODO: Navigate to album detail
      },
    );
  }

  Widget _buildArtistTile(Artist artist) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: CachedNetworkImageProvider(artist.profileImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        artist.name,
        style: const TextStyle(
          color: AppColors.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'Artist • ${artist.formattedFollowerCount} followers',
        style: const TextStyle(
          color: AppColors.lightGrey,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          _showArtistOptions(artist);
        },
        icon: const Icon(
          Icons.more_vert,
          color: AppColors.lightGrey,
        ),
      ),
      onTap: () {
        // TODO: Navigate to artist detail
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
        child: const Icon(
          Icons.download_done,
          color: AppColors.primary,
          size: 20,
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
          // TODO: Show track options
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

  void _showCreatePlaylistDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Create playlist',
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Playlist name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description (optional)',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<LibraryProvider>().createPlaylist(
                  nameController.text.trim(),
                  descriptionController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showPlaylistOptions(Playlist playlist) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: AppColors.onSurface),
            title: const Text('Edit playlist', style: TextStyle(color: AppColors.onSurface)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement edit playlist
            },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: AppColors.onSurface),
            title: const Text('Share', style: TextStyle(color: AppColors.onSurface)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement share
            },
          ),
          if (playlist.type == PlaylistType.userCreated)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete playlist', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                context.read<LibraryProvider>().deletePlaylist(playlist.id);
              },
            ),
        ],
      ),
    );
  }

  void _showAlbumOptions(Album album) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share, color: AppColors.onSurface),
            title: const Text('Share', style: TextStyle(color: AppColors.onSurface)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement share
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border, color: AppColors.onSurface),
            title: const Text('Remove from library', style: TextStyle(color: AppColors.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.read<LibraryProvider>().unsaveAlbum(album.id);
            },
          ),
        ],
      ),
    );
  }

  void _showArtistOptions(Artist artist) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share, color: AppColors.onSurface),
            title: const Text('Share', style: TextStyle(color: AppColors.onSurface)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement share
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove, color: AppColors.onSurface),
            title: const Text('Unfollow', style: TextStyle(color: AppColors.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.read<LibraryProvider>().unfollowArtist(artist.id);
            },
          ),
        ],
      ),
    );
  }
}