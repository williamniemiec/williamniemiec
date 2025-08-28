import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/video.dart';
import 'video_actions_sidebar.dart';
import 'video_description.dart';

class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final bool isPlaying;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.isPlaying,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  bool _isLiked = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.video.isLiked;
    _isBookmarked = widget.video.isBookmarked;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _onComment() {
    // TODO: Navigate to comments screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.largeBorderRadius),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppConstants.textSecondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Comments',
                style: AppTheme.usernameStyle,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Comments feature coming soon!',
                  style: TextStyle(color: AppConstants.textSecondaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShare() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: AppConstants.surfaceColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Stack(
        children: [
          // Video Player (placeholder with image)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // TODO: Toggle video play/pause
              },
              child: Container(
                color: Colors.black,
                child: widget.video.thumbnailUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.video.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppConstants.surfaceColor,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppConstants.surfaceColor,
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 80,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 80,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
              ),
            ),
          ),

          // Actions Sidebar (Right side)
          Positioned(
            right: 12,
            bottom: 100,
            child: VideoActionsSidebar(
              video: widget.video,
              isLiked: _isLiked,
              isBookmarked: _isBookmarked,
              onLike: _toggleLike,
              onComment: _onComment,
              onShare: _onShare,
              onBookmark: _toggleBookmark,
            ),
          ),

          // Video Description (Bottom left)
          Positioned(
            left: 12,
            right: 80,
            bottom: 100,
            child: VideoDescription(
              video: widget.video,
            ),
          ),
        ],
      ),
    );
  }
}