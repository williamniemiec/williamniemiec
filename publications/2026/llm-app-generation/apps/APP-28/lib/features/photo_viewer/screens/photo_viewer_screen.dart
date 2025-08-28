import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/photo.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';

class PhotoViewerScreen extends StatefulWidget {
  final Photo photo;
  final List<Photo> photos;
  final int initialIndex;
  final String? title;

  const PhotoViewerScreen({
    super.key,
    required this.photo,
    required this.photos,
    this.initialIndex = 0,
    this.title,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isAppBarVisible = true;
  bool _isBottomBarVisible = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Photo get currentPhoto => widget.photos[_currentIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _isAppBarVisible
          ? AppBar(
              backgroundColor: Colors.black54,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                widget.title ?? currentPhoto.name,
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () => _sharePhoto(currentPhoto),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => _showMoreOptions(currentPhoto),
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _toggleBarsVisibility,
        child: Stack(
          children: [
            // Photo gallery
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                final photo = widget.photos[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: _getImageProvider(photo),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained * 0.5,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  heroAttributes: PhotoViewHeroAttributes(tag: photo.id),
                  errorBuilder: (context, error, stackTrace) {
                    return _buildErrorWidget(photo);
                  },
                );
              },
              itemCount: widget.photos.length,
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            
            // Bottom toolbar
            if (_isBottomBarVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: currentPhoto.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            label: 'Favorite',
                            onPressed: () => _toggleFavorite(currentPhoto),
                          ),
                          _buildActionButton(
                            icon: Icons.edit,
                            label: 'Edit',
                            onPressed: () => _editPhoto(currentPhoto),
                          ),
                          _buildActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onPressed: () => _sharePhoto(currentPhoto),
                          ),
                          _buildActionButton(
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            onPressed: () => _deletePhoto(currentPhoto),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            
            // Photo counter
            if (_isAppBarVisible && widget.photos.length > 1)
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_currentIndex + 1} of ${widget.photos.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(Photo photo) {
    // For demo purposes, we'll use a placeholder
    // In a real app, this would load from the actual photo path
    return const AssetImage('assets/images/placeholder.png');
  }

  Widget _buildErrorWidget(Photo photo) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              photo.type == PhotoType.video
                  ? Icons.videocam_off
                  : Icons.broken_image,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load ${photo.type.displayName.toLowerCase()}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              photo.name,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _toggleBarsVisibility() {
    setState(() {
      _isAppBarVisible = !_isAppBarVisible;
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }

  void _toggleFavorite(Photo photo) {
    Provider.of<AppProvider>(context, listen: false).toggleFavorite(photo.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          photo.isFavorite
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _editPhoto(Photo photo) {
    // TODO: Navigate to photo editor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${photo.name}'),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _sharePhoto(Photo photo) {
    // TODO: Implement photo sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${photo.name}'),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _deletePhoto(Photo photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete photo',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${photo.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AppProvider>(context, listen: false).deletePhoto(photo.id);
              
              // Remove from current list and update UI
              widget.photos.removeAt(_currentIndex);
              if (widget.photos.isEmpty) {
                Navigator.of(context).pop();
              } else {
                if (_currentIndex >= widget.photos.length) {
                  _currentIndex = widget.photos.length - 1;
                }
                setState(() {});
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo deleted'),
                  backgroundColor: Colors.black87,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(Photo photo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('Photo info', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _showPhotoInfo(photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.white),
            title: const Text('Download', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _downloadPhoto(photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album, color: Colors.white),
            title: const Text('Add to album', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _addToAlbum(photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy, color: Colors.white),
            title: const Text('Copy', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _copyPhoto(photo);
            },
          ),
        ],
      ),
    );
  }

  void _showPhotoInfo(Photo photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          photo.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Date', photo.dateCreated.toString().split('.')[0]),
            _buildInfoRow('Size', '${(photo.size / 1024 / 1024).toStringAsFixed(1)} MB'),
            _buildInfoRow('Dimensions', '${photo.width} × ${photo.height}'),
            if (photo.location != null) _buildInfoRow('Location', photo.location!),
            if (photo.tags.isNotEmpty) _buildInfoRow('Tags', photo.tags.join(', ')),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPhoto(Photo photo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${photo.name}'),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _addToAlbum(Photo photo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding ${photo.name} to album'),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _copyPhoto(Photo photo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied ${photo.name}'),
        backgroundColor: Colors.black87,
      ),
    );
  }
}