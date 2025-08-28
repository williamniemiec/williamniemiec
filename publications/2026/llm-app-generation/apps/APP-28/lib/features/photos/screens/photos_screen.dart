import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/photo.dart';
import '../../../shared/models/album.dart';
import '../widgets/photo_grid_item.dart';
import '../widgets/memories_carousel.dart';
import '../../photo_viewer/screens/photo_viewer_screen.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<int>(
                icon: const Icon(Icons.grid_view),
                onSelected: (value) {
                  provider.updateGridCrossAxisCount(value);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_on,
                          color: provider.gridCrossAxisCount == 2
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Large'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_on,
                          color: provider.gridCrossAxisCount == 3
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Medium'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_on,
                          color: provider.gridCrossAxisCount == 4
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Small'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 5,
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_on,
                          color: provider.gridCrossAxisCount == 5
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text('Tiny'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreOptions(context);
            },
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
                    onPressed: () => provider.loadPhotos(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final photos = provider.recentPhotos;
          final memories = provider.memories;

          if (photos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppConstants.noPhotosMessage,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Memories carousel
              if (memories.isNotEmpty)
                SliverToBoxAdapter(
                  child: MemoriesCarousel(
                    memories: memories,
                    onMemoryTap: (memory) => _openMemory(context, memory),
                  ),
                ),
              
              // Photos grid
              SliverPadding(
                padding: const EdgeInsets.all(2.0),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: provider.gridCrossAxisCount,
                  mainAxisSpacing: AppConstants.gridSpacing,
                  crossAxisSpacing: AppConstants.gridSpacing,
                  childCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return PhotoGridItem(
                      photo: photo,
                      onTap: () => _openPhoto(context, photo, photos, index),
                      onLongPress: () => _showPhotoOptions(context, photo),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPhoto(context),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  void _openPhoto(BuildContext context, Photo photo, List<Photo> photos, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photo: photo,
          photos: photos,
          initialIndex: index,
        ),
      ),
    );
  }

  void _openMemory(BuildContext context, Memory memory) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final memoryPhotos = memory.photoIds
        .map((id) => provider.getPhotoById(id))
        .where((photo) => photo != null)
        .cast<Photo>()
        .toList();

    if (memoryPhotos.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoViewerScreen(
            photo: memoryPhotos.first,
            photos: memoryPhotos,
            initialIndex: 0,
            title: memory.title,
          ),
        ),
      );
    }
  }

  void _showPhotoOptions(BuildContext context, Photo photo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              photo.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            title: Text(photo.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
            onTap: () {
              Navigator.pop(context);
              Provider.of<AppProvider>(context, listen: false).toggleFavorite(photo.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              _sharePhoto(context, photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              _editPhoto(context, photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Info'),
            onTap: () {
              Navigator.pop(context);
              _showPhotoInfo(context, photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _deletePhoto(context, photo);
            },
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.select_all),
            title: const Text('Select photos'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement multi-select mode
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & sync'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to backup settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
    );
  }

  void _addPhoto(BuildContext context) {
    // TODO: Implement photo picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo picker not implemented yet'),
      ),
    );
  }

  void _sharePhoto(BuildContext context, Photo photo) {
    // TODO: Implement photo sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${photo.name}'),
      ),
    );
  }

  void _editPhoto(BuildContext context, Photo photo) {
    // TODO: Navigate to photo editor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${photo.name}'),
      ),
    );
  }

  void _showPhotoInfo(BuildContext context, Photo photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(photo.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${photo.dateCreated.toString().split('.')[0]}'),
            Text('Size: ${(photo.size / 1024 / 1024).toStringAsFixed(1)} MB'),
            Text('Dimensions: ${photo.width} × ${photo.height}'),
            if (photo.location != null) Text('Location: ${photo.location}'),
            if (photo.tags.isNotEmpty) Text('Tags: ${photo.tags.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deletePhoto(BuildContext context, Photo photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete photo'),
        content: Text('Are you sure you want to delete "${photo.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AppProvider>(context, listen: false).deletePhoto(photo.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photo deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}