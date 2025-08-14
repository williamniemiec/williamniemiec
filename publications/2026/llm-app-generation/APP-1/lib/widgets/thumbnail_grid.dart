import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photon_gallery/widgets/media_item.dart' as photon_media_item;
import 'package:photon_gallery/services/media_service.dart';
import 'package:photon_gallery/services/cache_service.dart';
import 'package:photon_gallery/services/prefetch_service.dart';

class ThumbnailGrid extends StatefulWidget {
  final MediaService mediaService;
  final CacheService cacheService;
  final PrefetchService prefetchService;

  const ThumbnailGrid({
    Key? key,
    required this.mediaService,
    required this.cacheService,
    required this.prefetchService,
  }) : super(key: key);

  @override
  _ThumbnailGridState createState() => _ThumbnailGridState();
}

class _ThumbnailGridState extends State<ThumbnailGrid> {
  late Future<List<MediaItem>> _mediaItemsFuture;
  int _crossAxisCount = 3; // Default number of columns
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _mediaItemsFuture = widget.mediaService.getMediaItems();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MediaItem>>(
      future: _mediaItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading media items'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No media items found'));
        } else {
          final mediaItems = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  GestureDetector(
                    onScaleUpdate: (details) {
                      // Handle pinch-to-zoom gesture to adjust grid size
                      setState(() {
                        _crossAxisCount = (details.scale * 3).round().clamp(2, 6);
                      });
                    },
                    child: MasonryGridView.count(
                      controller: _scrollController,
                      crossAxisCount: _crossAxisCount,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: mediaItems.length,
                      itemBuilder: (context, index) {
                        return photon_media_item.MediaItemWidget(
                          mediaItem: mediaItems[index],
                          cacheService: widget.cacheService,
                        );
                      },
                    ),
                  ),
                  // Fast-scroll handle
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          // Calculate the scroll position based on drag position
                          final RenderBox renderBox = context.findRenderObject() as RenderBox;
                          final position = details.localPosition;
                          final scrollPosition = (position.dy / renderBox.size.height) * _scrollController.position.maxScrollExtent;
                          _scrollController.jumpTo(scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent));
                        },
                        child: Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}