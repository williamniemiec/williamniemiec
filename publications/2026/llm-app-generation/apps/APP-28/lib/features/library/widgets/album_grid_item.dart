import 'package:flutter/material.dart';
import '../../../shared/models/album.dart';

class AlbumGridItem extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const AlbumGridItem({
    super.key,
    required this.album,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Album cover placeholder
                      _buildAlbumCover(),
                      
                      // Photo count overlay
                      if (album.photoCount > 0)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${album.photoCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      
                      // Shared indicator
                      if (album.isShared)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Album info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      album.description ?? '${album.photoCount} photo${album.photoCount == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildAlbumCover() {
    // For demo purposes, we'll use a gradient background with an icon
    // In a real app, this would show the actual cover photo
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getAlbumGradientColors(),
        ),
      ),
      child: Center(
        child: Icon(
          _getAlbumIcon(),
          size: 48,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  IconData _getAlbumIcon() {
    switch (album.type) {
      case AlbumType.favorites:
        return Icons.favorite;
      case AlbumType.screenshots:
        return Icons.screenshot;
      case AlbumType.camera:
        return Icons.photo_camera;
      case AlbumType.downloads:
        return Icons.download;
      case AlbumType.shared:
        return Icons.people;
      case AlbumType.archive:
        return Icons.archive;
      case AlbumType.trash:
        return Icons.delete;
      case AlbumType.custom:
      default:
        return Icons.photo_album;
    }
  }

  List<Color> _getAlbumGradientColors() {
    switch (album.type) {
      case AlbumType.favorites:
        return [Colors.red[400]!, Colors.red[600]!];
      case AlbumType.screenshots:
        return [Colors.purple[400]!, Colors.purple[600]!];
      case AlbumType.camera:
        return [Colors.blue[400]!, Colors.blue[600]!];
      case AlbumType.downloads:
        return [Colors.green[400]!, Colors.green[600]!];
      case AlbumType.shared:
        return [Colors.orange[400]!, Colors.orange[600]!];
      case AlbumType.archive:
        return [Colors.grey[400]!, Colors.grey[600]!];
      case AlbumType.trash:
        return [Colors.red[800]!, Colors.red[900]!];
      case AlbumType.custom:
      default:
        return [Colors.teal[400]!, Colors.teal[600]!];
    }
  }
}

class AlbumGridShimmer extends StatelessWidget {
  const AlbumGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}