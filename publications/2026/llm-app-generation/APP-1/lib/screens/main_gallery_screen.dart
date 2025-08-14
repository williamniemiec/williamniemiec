import 'package:flutter/material.dart';
import 'package:photon_gallery/widgets/thumbnail_grid.dart';
import 'package:photon_gallery/services/media_service.dart';
import 'package:photon_gallery/services/cache_service.dart';
import 'package:photon_gallery/services/prefetch_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MainGalleryScreen extends StatefulWidget {
  @override
  _MainGalleryScreenState createState() => _MainGalleryScreenState();
}

class _MainGalleryScreenState extends State<MainGalleryScreen> {
  late MediaService _mediaService;
  late CacheService _cacheService;
  late PrefetchService _prefetchService;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _mediaService = MediaService();
    _cacheService = CacheService();
    _prefetchService = PrefetchService();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
      // Start background caching and prefetching
      _cacheService.startCaching();
      _prefetchService.startPrefetching();
    } else {
      // Handle permission denied
      // For now, we'll just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access photos is required.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _permissionsGranted
          ? Stack(
              children: [
                ThumbnailGrid(
                  mediaService: _mediaService,
                  cacheService: _cacheService,
                  prefetchService: _prefetchService,
                ),
                // Minimal Header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Date range (placeholder)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'August 2025', // This would be dynamic in a real app
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Search icon
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // Handle search action
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Permission to access photos is required.'),
                  ElevatedButton(
                    onPressed: _requestPermissions,
                    child: Text('Grant Permission'),
                  ),
                ],
              ),
            ),
    );
  }
}