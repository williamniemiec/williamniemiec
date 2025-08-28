import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/device.dart';

class MediaPlayerCard extends StatelessWidget {
  final Device device;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const MediaPlayerCard({
    super.key,
    required this.device,
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = device.properties['isPlaying'] as bool? ?? false;
    final currentSong = device.properties['currentSong'] as String? ?? 'Unknown Track';
    final currentArtist = device.properties['currentArtist'] as String? ?? 'Unknown Artist';
    final volume = device.volume;

    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    MdiIcons.speaker,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Playing on ${device.name}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        currentSong,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentArtist,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Progress bar (mock)
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.4, // Mock progress
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Volume control
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      volume > 50
                          ? Icons.volume_up
                          : volume > 0
                              ? Icons.volume_down
                              : Icons.volume_off,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$volume%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),

                // Playback controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onPrevious,
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 28,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: isPlaying ? onPause : onPlay,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        iconSize: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: onNext,
                      icon: const Icon(Icons.skip_next),
                      iconSize: 28,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),

                // More options
                IconButton(
                  onPressed: () => _showMoreOptions(context),
                  icon: const Icon(Icons.more_vert),
                  iconSize: 20,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cast),
              title: const Text('Cast to device'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: const Text('View queue'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Volume control'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.stop),
              title: const Text('Stop playback'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}