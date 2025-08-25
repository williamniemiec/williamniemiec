import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock provider for current playback state
final currentPlaybackProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayback = ref.watch(currentPlaybackProvider);
    
    // Don't show mini player if nothing is playing
    if (currentPlayback == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to full player screen
            _showFullPlayer(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Cover Art
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.headphones, size: 30),
                ),
                
                const SizedBox(width: 12),
                
                // Title and Author
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentPlayback['title'] ?? 'Unknown Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentPlayback['author'] ?? 'Unknown Author',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Progress bar
                      LinearProgressIndicator(
                        value: currentPlayback['progress'] ?? 0.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Play/Pause Button
                IconButton(
                  onPressed: () {
                    _togglePlayPause(ref);
                  },
                  icon: Icon(
                    currentPlayback['isPlaying'] == true
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 32,
                  ),
                ),
                
                // Close Button
                IconButton(
                  onPressed: () {
                    _stopPlayback(ref);
                  },
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePlayPause(WidgetRef ref) {
    final currentPlayback = ref.read(currentPlaybackProvider);
    if (currentPlayback != null) {
      final updatedPlayback = Map<String, dynamic>.from(currentPlayback);
      updatedPlayback['isPlaying'] = !(currentPlayback['isPlaying'] ?? false);
      ref.read(currentPlaybackProvider.notifier).state = updatedPlayback;
    }
  }

  void _stopPlayback(WidgetRef ref) {
    ref.read(currentPlaybackProvider.notifier).state = null;
  }

  void _showFullPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FullPlayerScreen(),
      ),
    );
  }
}

class FullPlayerScreen extends ConsumerWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayback = ref.watch(currentPlaybackProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showPlayerMenu(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            
            // Cover Art
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.headphones, size: 100),
            ),
            
            const SizedBox(height: 32),
            
            // Title and Author
            Text(
              currentPlayback?['title'] ?? 'Unknown Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              currentPlayback?['author'] ?? 'Unknown Author',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Progress Slider
            Column(
              children: [
                Slider(
                  value: currentPlayback?['progress'] ?? 0.0,
                  onChanged: (value) {
                    // TODO: Seek to position
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(Duration(
                          seconds: ((currentPlayback?['progress'] ?? 0.0) * 3600).round(),
                        )),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDuration(const Duration(hours: 1)),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Previous chapter/track
                  },
                  icon: const Icon(Icons.skip_previous, size: 32),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Rewind 30 seconds
                  },
                  icon: const Icon(Icons.replay_30, size: 32),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _togglePlayPause(ref);
                    },
                    icon: Icon(
                      currentPlayback?['isPlaying'] == true
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Forward 30 seconds
                  },
                  icon: const Icon(Icons.forward_30, size: 32),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Next chapter/track
                  },
                  icon: const Icon(Icons.skip_next, size: 32),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Secondary Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Show chapters
                  },
                  icon: const Icon(Icons.list),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Adjust speed
                  },
                  icon: const Icon(Icons.speed),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Sleep timer
                  },
                  icon: const Icon(Icons.bedtime),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Add bookmark
                  },
                  icon: const Icon(Icons.bookmark_add),
                ),
              ],
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _togglePlayPause(WidgetRef ref) {
    final currentPlayback = ref.read(currentPlaybackProvider);
    if (currentPlayback != null) {
      final updatedPlayback = Map<String, dynamic>.from(currentPlayback);
      updatedPlayback['isPlaying'] = !(currentPlayback['isPlaying'] ?? false);
      ref.read(currentPlaybackProvider.notifier).state = updatedPlayback;
    }
  }

  void _showPlayerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Download functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Add to Wishlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add to wishlist
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}

// Demo function to simulate starting playback
void startDemoPlayback(WidgetRef ref) {
  ref.read(currentPlaybackProvider.notifier).state = {
    'title': 'The Great Gatsby',
    'author': 'F. Scott Fitzgerald',
    'progress': 0.3,
    'isPlaying': true,
  };
}