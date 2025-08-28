import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_theme.dart';
import '../../features/player/providers/player_provider.dart';
import '../../features/player/screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        final currentTrack = playerProvider.currentTrack;
        if (currentTrack == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const PlayerScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Album art
                Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(currentTrack.albumArt),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: currentTrack.albumArt,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.grey.withOpacity(0.3),
                      child: const Icon(
                        Icons.music_note,
                        color: AppColors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey.withOpacity(0.3),
                      child: const Icon(
                        Icons.music_note,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
                
                // Track info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTrack.title,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentTrack.artist,
                          style: const TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Like button
                IconButton(
                  onPressed: () {
                    // TODO: Implement like functionality
                  },
                  icon: Icon(
                    currentTrack.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: currentTrack.isLiked ? AppColors.primary : AppColors.lightGrey,
                    size: 20,
                  ),
                ),
                
                // Play/Pause button
                IconButton(
                  onPressed: () {
                    if (playerProvider.isPlaying) {
                      playerProvider.pause();
                    } else {
                      playerProvider.play();
                    }
                  },
                  icon: Icon(
                    playerProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}