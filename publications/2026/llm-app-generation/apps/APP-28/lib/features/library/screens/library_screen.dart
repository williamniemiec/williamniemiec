import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/album.dart';
import '../widgets/album_grid_item.dart';
import '../widgets/library_section.dart';
import '../widgets/create_album_dialog.dart';
import '../../photo_viewer/screens/photo_viewer_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search with library filter
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _openSettings();
                  break;
                case 'backup':
                  _openBackupSettings();
                  break;
                case 'help':
                  _openHelp();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'backup',
                child: ListTile(
                  leading: Icon(Icons.backup),
                  title: Text('Backup & sync'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Help & feedback'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadAlbums(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick actions
                _buildQuickActions(context, provider),
                
                const SizedBox(height: 24),
                
                // Photos on device
                _buildPhotosOnDevice(context, provider),
                
                const SizedBox(height: 24),
                
                // Albums section
                _buildAlbumsSection(context, provider),
                
                const SizedBox(height: 24),
                
                // Utilities section
                _buildUtilitiesSection(context, provider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAlbumDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New album'),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppProvider provider) {
    return LibrarySection(
      title: 'Quick access',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.favorite,
                title: 'Favorites',
                subtitle: '${provider.favoritePhotos.length} photos',
                color: Colors.red,
                onTap: () => _openFavorites(context, provider),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.phone_android,
                title: 'On device',
                subtitle: '${provider.photos.length} photos',
                color: Colors.blue,
                onTap: () => _openDevicePhotos(context, provider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosOnDevice(BuildContext context, AppProvider provider) {
    return LibrarySection(
      title: 'Photos on device',
      children: [
        ListTile(
          leading: const Icon(Icons.photo_camera),
          title: const Text('Camera'),
          subtitle: Text('${provider.photos.where((p) => p.tags.contains('camera')).length} photos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openCameraPhotos(context, provider),
        ),
        ListTile(
          leading: const Icon(Icons.screenshot),
          title: const Text('Screenshots'),
          subtitle: Text('${provider.photos.where((p) => p.tags.contains('screenshot')).length} photos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openScreenshots(context, provider),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Downloads'),
          subtitle: Text('${provider.photos.where((p) => p.tags.contains('download')).length} photos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openDownloads(context, provider),
        ),
      ],
    );
  }

  Widget _buildAlbumsSection(BuildContext context, AppProvider provider) {
    final userAlbums = provider.albums.where((album) => !album.isSystemAlbum).toList();
    
    return LibrarySection(
      title: 'Albums',
      action: TextButton(
        onPressed: () => _showCreateAlbumDialog(context),
        child: const Text('Create'),
      ),
      children: [
        if (userAlbums.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.photo_album_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.noAlbumsMessage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create albums to organize your photos',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: userAlbums.length,
            itemBuilder: (context, index) {
              final album = userAlbums[index];
              return AlbumGridItem(
                album: album,
                onTap: () => _openAlbum(context, album, provider),
                onLongPress: () => _showAlbumOptions(context, album),
              );
            },
          ),
      ],
    );
  }

  Widget _buildUtilitiesSection(BuildContext context, AppProvider provider) {
    return LibrarySection(
      title: 'Utilities',
      children: [
        ListTile(
          leading: const Icon(Icons.archive_outlined),
          title: const Text('Archive'),
          subtitle: const Text('Hide photos from main view'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openArchive(context),
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Trash'),
          subtitle: const Text('Recently deleted photos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openTrash(context),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Free up space'),
          subtitle: const Text('Remove backed-up photos from device'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openFreeUpSpace(context),
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Shared albums'),
          subtitle: Text('${provider.albums.where((a) => a.isShared).length} albums'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openSharedAlbums(context, provider),
        ),
      ],
    );
  }

  void _showCreateAlbumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateAlbumDialog(),
    );
  }

  void _openFavorites(BuildContext context, AppProvider provider) {
    final favorites = provider.favoritePhotos;
    if (favorites.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: favorites.first,
            photos: favorites,
            initialIndex: 0,
            title: 'Favorites',
          ),
        ),
      );
    }
  }

  void _openDevicePhotos(BuildContext context, AppProvider provider) {
    final photos = provider.photos;
    if (photos.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: photos.first,
            photos: photos,
            initialIndex: 0,
            title: 'Photos on device',
          ),
        ),
      );
    }
  }

  void _openCameraPhotos(BuildContext context, AppProvider provider) {
    final cameraPhotos = provider.photos.where((p) => p.tags.contains('camera')).toList();
    if (cameraPhotos.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: cameraPhotos.first,
            photos: cameraPhotos,
            initialIndex: 0,
            title: 'Camera',
          ),
        ),
      );
    }
  }

  void _openScreenshots(BuildContext context, AppProvider provider) {
    final screenshots = provider.photos.where((p) => p.tags.contains('screenshot')).toList();
    if (screenshots.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: screenshots.first,
            photos: screenshots,
            initialIndex: 0,
            title: 'Screenshots',
          ),
        ),
      );
    }
  }

  void _openDownloads(BuildContext context, AppProvider provider) {
    final downloads = provider.photos.where((p) => p.tags.contains('download')).toList();
    if (downloads.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: downloads.first,
            photos: downloads,
            initialIndex: 0,
            title: 'Downloads',
          ),
        ),
      );
    }
  }

  void _openAlbum(BuildContext context, Album album, AppProvider provider) {
    final albumPhotos = provider.getPhotosForAlbum(album.id);
    if (albumPhotos.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: albumPhotos.first,
            photos: albumPhotos,
            initialIndex: 0,
            title: album.name,
          ),
        ),
      );
    }
  }

  void _showAlbumOptions(BuildContext context, Album album) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit album'),
            onTap: () {
              Navigator.pop(context);
              _editAlbum(context, album);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share album'),
            onTap: () {
              Navigator.pop(context);
              _shareAlbum(context, album);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete album'),
            onTap: () {
              Navigator.pop(context);
              _deleteAlbum(context, album);
            },
          ),
        ],
      ),
    );
  }

  void _editAlbum(BuildContext context, Album album) {
    // TODO: Implement album editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${album.name}')),
    );
  }

  void _shareAlbum(BuildContext context, Album album) {
    // TODO: Implement album sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${album.name}')),
    );
  }

  void _deleteAlbum(BuildContext context, Album album) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete album'),
        content: Text('Are you sure you want to delete "${album.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AppProvider>(context, listen: false).deleteAlbum(album.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Album deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openArchive(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Archive not implemented yet')),
    );
  }

  void _openTrash(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trash not implemented yet')),
    );
  }

  void _openFreeUpSpace(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Free up space not implemented yet')),
    );
  }

  void _openSharedAlbums(BuildContext context, AppProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shared albums not implemented yet')),
    );
  }

  void _openSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings not implemented yet')),
    );
  }

  void _openBackupSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup settings not implemented yet')),
    );
  }

  void _openHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help not implemented yet')),
    );
  }
}