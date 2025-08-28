import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/video.dart';
import '../../../shared/models/user.dart';
import 'video_player_item.dart';

enum FeedType { forYou, following }

class VideoFeed extends StatefulWidget {
  final FeedType feedType;

  const VideoFeed({
    super.key,
    required this.feedType,
  });

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadMockVideos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadMockVideos() {
    // Mock data for demonstration
    final mockUser = User(
      id: '1',
      username: 'user123',
      displayName: 'John Doe',
      email: 'john@example.com',
      profileImageUrl: AppConstants.placeholderProfileImage,
      bio: 'Content creator',
      followersCount: 1000,
      followingCount: 500,
      likesCount: 5000,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _videos = List.generate(10, (index) => Video(
      id: 'video_$index',
      videoUrl: AppConstants.placeholderVideoUrl,
      thumbnailUrl: AppConstants.placeholderImageUrl,
      caption: 'This is a sample video caption #${index + 1} #tiktok #flutter',
      hashtags: ['${index + 1}', 'tiktok', 'flutter'],
      creator: mockUser,
      duration: 30,
      likesCount: (index + 1) * 100,
      commentsCount: (index + 1) * 20,
      sharesCount: (index + 1) * 10,
      viewsCount: (index + 1) * 1000,
      createdAt: DateTime.now().subtract(Duration(hours: index)),
      updatedAt: DateTime.now().subtract(Duration(hours: index)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_videos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppConstants.primaryColor,
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        return VideoPlayerItem(
          video: _videos[index],
          isPlaying: index == _currentIndex,
        );
      },
    );
  }
}