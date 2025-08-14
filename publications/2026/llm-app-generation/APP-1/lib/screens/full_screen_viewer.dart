import 'package:flutter/material.dart';
import 'package:photon_gallery/services/media_service.dart';

class FullScreenViewer extends StatefulWidget {
  final MediaItem mediaItem;

  const FullScreenViewer({Key? key, required this.mediaItem}) : super(key: key);

  @override
  _FullScreenViewerState createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenViewer> {
  bool _showControls = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Media display (placeholder for now)
            Container(
              color: _getColorForMediaItem(widget.mediaItem),
              child: widget.mediaItem.isVideo
                  ? Icon(Icons.play_arrow, color: Colors.white, size: 100)
                  : null,
            ),
            // Transient controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          // Handle share action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.white),
                        onPressed: () {
                          // Handle favorite action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          // Handle delete action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info, color: Colors.white),
                        onPressed: () {
                          // Handle details action
                        },
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