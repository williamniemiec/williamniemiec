import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewerScreen extends StatefulWidget {
  final String mediaUrl;

  const MediaViewerScreen({super.key, required this.mediaUrl});

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.mediaUrl.endsWith('.mp4')) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      );
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    }
  }

  @override
  void dispose() {
    if (widget.mediaUrl.endsWith('.mp4')) {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Center(
          child: widget.mediaUrl.endsWith('.mp4')
              ? Chewie(controller: _chewieController!)
              : CachedNetworkImage(
                  imageUrl: widget.mediaUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ),
      ),
    );
  }
}
