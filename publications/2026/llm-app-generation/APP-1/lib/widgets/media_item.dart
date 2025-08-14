import 'package:flutter/material.dart';
import 'package:photon_gallery/services/media_service.dart';
import 'package:photon_gallery/services/cache_service.dart';
import 'package:photon_gallery/screens/full_screen_viewer.dart';

class MediaItemWidget extends StatelessWidget {
  final MediaItem mediaItem;
  final CacheService cacheService;

  const MediaItemWidget({
    Key? key,
    required this.mediaItem,
    required this.cacheService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: Colors.grey[300]);
        } else if (snapshot.hasError) {
          return Container(color: Colors.red);
        } else {
          // For now, we'll just display a placeholder colored container
          // In a real app, you would display the actual thumbnail image
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenViewer(mediaItem: mediaItem),
                ),
              );
            },
            child: Container(
              color: _getColorForMediaItem(mediaItem),
              child: mediaItem.isVideo
                  ? Icon(Icons.play_arrow, color: Colors.white)
                  : null,
            ),
          );
        }
      },
    );
  }

  Future<void> _getThumbnail() async {
    // In a real app, you would use the cacheService to get the cached thumbnail
    // or generate a new one if it doesn't exist.
    // For now, we'll just simulate the process.
    await Future.delayed(Duration(milliseconds: 100));
  }

  Color _getColorForMediaItem(MediaItem mediaItem) {
    // Generate a color based on the media item's ID for visual distinction
    // This is a simple hash function to generate a color
    int hash = 0;
    for (int i = 0; i < mediaItem.id.length; i++) {
      hash = hash * 31 + mediaItem.id.codeUnitAt(i);
    }
    // Ensure the hash is positive and within the range of 0-0xFFFFFF
    hash = hash.abs() % 0x1000000;
    return Color(0xFF000000 + hash);
  }
}