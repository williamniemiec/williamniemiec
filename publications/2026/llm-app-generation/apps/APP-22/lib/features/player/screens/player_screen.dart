import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/audio_service.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with TickerProviderStateMixin {
  late AnimationController _albumArtController;
  late Animation<double> _albumArtAnimation;

  @override
  void initState() {
    super.initState();
    _albumArtController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _albumArtAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_albumArtController);
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlayerProvider>(
        builder: (context, playerProvider, child) {
          final currentTrack = playerProvider.currentTrack;
          
          // Start/stop album art rotation based on play state
          if (playerProvider.isPlaying) {
            _albumArtController.repeat();
          } else {
            _albumArtController.stop();
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.8),
                  AppColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.onBackground,
                            size: 32,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'PLAYING FROM PLAYLIST',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.lightGrey,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Liked Songs', // TODO: Get actual playlist name
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.onBackground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Show more options
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppColors.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Album Art
                  if (currentTrack != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: AnimatedBuilder(
                          animation: _albumArtAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _albumArtAnimation.value * 2 * 3.14159,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: currentTrack.albumArt,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppColors.grey.withOpacity(0.3),
                                      child: const Icon(
                                        Icons.music_note,
                                        color: AppColors.grey,
                                        size: 80,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: AppColors.grey.withOpacity(0.3),
                                      child: const Icon(
                                        Icons.music_note,
                                        color: AppColors.grey,
                                        size: 80,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Track Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentTrack.title,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentTrack.artist,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.lightGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // TODO: Toggle like
                            },
                            icon: Icon(
                              currentTrack.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: currentTrack.isLiked ? AppColors.primary : AppColors.lightGrey,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                            ),
                            child: Slider(
                              value: playerProvider.progress.clamp(0.0, 1.0),
                              onChanged: (value) {
                                if (playerProvider.duration != null) {
                                  final position = Duration(
                                    milliseconds: (value * playerProvider.duration!.inMilliseconds).round(),
                                  );
                                  playerProvider.seekTo(position);
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                playerProvider.formattedPosition,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lightGrey,
                                ),
                              ),
                              Text(
                                playerProvider.formattedDuration,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lightGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Controls
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Shuffle
                          IconButton(
                            onPressed: () => playerProvider.toggleShuffle(),
                            icon: Icon(
                              Icons.shuffle,
                              color: playerProvider.isShuffleEnabled 
                                  ? AppColors.primary 
                                  : AppColors.lightGrey,
                              size: 28,
                            ),
                          ),

                          // Previous
                          IconButton(
                            onPressed: playerProvider.hasPrevious 
                                ? () => playerProvider.skipToPrevious()
                                : null,
                            icon: Icon(
                              Icons.skip_previous,
                              color: playerProvider.hasPrevious 
                                  ? AppColors.onBackground 
                                  : AppColors.grey,
                              size: 40,
                            ),
                          ),

                          // Play/Pause
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: AppColors.onBackground,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (playerProvider.isPlaying) {
                                  playerProvider.pause();
                                } else {
                                  playerProvider.play();
                                }
                              },
                              icon: Icon(
                                playerProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: AppColors.background,
                                size: 36,
                              ),
                            ),
                          ),

                          // Next
                          IconButton(
                            onPressed: playerProvider.hasNext 
                                ? () => playerProvider.skipToNext()
                                : null,
                            icon: Icon(
                              Icons.skip_next,
                              color: playerProvider.hasNext 
                                  ? AppColors.onBackground 
                                  : AppColors.grey,
                              size: 40,
                            ),
                          ),

                          // Repeat
                          IconButton(
                            onPressed: () => playerProvider.toggleRepeat(),
                            icon: Icon(
                              playerProvider.repeatMode == RepeatMode.one
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              color: playerProvider.repeatMode != RepeatMode.off
                                  ? AppColors.primary
                                  : AppColors.lightGrey,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bottom Controls
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              // TODO: Show devices
                            },
                            icon: const Icon(
                              Icons.devices,
                              color: AppColors.lightGrey,
                              size: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // TODO: Show share options
                            },
                            icon: const Icon(
                              Icons.share,
                              color: AppColors.lightGrey,
                              size: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              playerProvider.toggleQueue();
                            },
                            icon: Icon(
                              Icons.queue_music,
                              color: playerProvider.showQueue 
                                  ? AppColors.primary 
                                  : AppColors.lightGrey,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // No track playing
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_off,
                              size: 64,
                              color: AppColors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No music playing',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}