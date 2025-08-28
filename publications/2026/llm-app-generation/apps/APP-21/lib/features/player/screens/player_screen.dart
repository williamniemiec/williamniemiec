import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/song.dart';

// Provider for current playing song
final currentSongProvider = StateProvider<Song?>((ref) => null);

// Provider for player state
final isPlayingProvider = StateProvider<bool>((ref) => false);

// Provider for playback position
final playbackPositionProvider = StateProvider<Duration>((ref) => Duration.zero);

// Provider for video mode toggle
final isVideoModeProvider = StateProvider<bool>((ref) => false);

// Provider for shuffle mode
final isShuffleProvider = StateProvider<bool>((ref) => false);

// Provider for repeat mode (0: off, 1: all, 2: one)
final repeatModeProvider = StateProvider<int>((ref) => 0);

// Provider for volume
final volumeProvider = StateProvider<double>((ref) => 0.8);

class PlayerScreen extends ConsumerStatefulWidget {
  final Song song;
  
  const PlayerScreen({
    super.key,
    required this.song,
  });

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _albumArtController;
  late AnimationController _progressController;
  late Animation<double> _albumArtAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _albumArtController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: widget.song.duration,
      vsync: this,
    );
    
    _albumArtAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _albumArtController,
      curve: Curves.linear,
    ));
    
    // Set current song
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentSongProvider.notifier).state = widget.song;
    });
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final isPlaying = ref.read(isPlayingProvider);
    ref.read(isPlayingProvider.notifier).state = !isPlaying;
    
    if (!isPlaying) {
      _albumArtController.repeat();
      _progressController.forward();
    } else {
      _albumArtController.stop();
      _progressController.stop();
    }
  }

  void _toggleVideoMode() {
    final isVideoMode = ref.read(isVideoModeProvider);
    ref.read(isVideoModeProvider.notifier).state = !isVideoMode;
  }

  void _toggleShuffle() {
    final isShuffle = ref.read(isShuffleProvider);
    ref.read(isShuffleProvider.notifier).state = !isShuffle;
  }

  void _toggleRepeat() {
    final repeatMode = ref.read(repeatModeProvider);
    ref.read(repeatModeProvider.notifier).state = (repeatMode + 1) % 3;
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(isPlayingProvider);
    final isVideoMode = ref.watch(isVideoModeProvider);
    final isShuffle = ref.watch(isShuffleProvider);
    final repeatMode = ref.watch(repeatModeProvider);
    final volume = ref.watch(volumeProvider);

    return Scaffold(
      backgroundColor: AppColors.playerBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.playerGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              _buildTopBar(),
              
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Album Art / Video Player
                      Expanded(
                        flex: 3,
                        child: _buildMediaDisplay(isVideoMode),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Song Info
                      _buildSongInfo(),
                      
                      const SizedBox(height: 30),
                      
                      // Progress Bar
                      _buildProgressBar(),
                      
                      const SizedBox(height: 30),
                      
                      // Playback Controls
                      _buildPlaybackControls(isPlaying, isShuffle, repeatMode),
                      
                      const SizedBox(height: 20),
                      
                      // Action Bar
                      _buildActionBar(isVideoMode),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            color: AppColors.textPrimaryDark,
            iconSize: 32,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Column(
            children: [
              Text(
                'PLAYING FROM PLAYLIST',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Your Mix',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: AppColors.textPrimaryDark,
            onPressed: () {
              // TODO: Show more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMediaDisplay(bool isVideoMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.playerShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: isVideoMode ? 16 / 9 : 1,
          child: Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.secondary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              
              // Album Art or Video
              if (isVideoMode)
                _buildVideoPlayer()
              else
                _buildAlbumArt(),
              
              // Video/Audio Toggle Button
              Positioned(
                top: 16,
                right: 16,
                child: _buildVideoToggleButton(isVideoMode),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return AnimatedBuilder(
      animation: _albumArtAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _albumArtAnimation.value * 2 * 3.14159,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardDark,
            ),
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  size: 80,
                  color: AppColors.textPrimaryDark,
                ),
                const SizedBox(height: 16),
                Text(
                  'Music Video',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
          ),
          
          // Video controls overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoToggleButton(bool isVideoMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _toggleVideoMode,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isVideoMode ? Icons.music_note : Icons.videocam,
                  color: AppColors.textPrimaryDark,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isVideoMode ? 'Song' : 'Video',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Column(
      children: [
        Text(
          widget.song.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          widget.song.artist,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textSecondaryDark,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            final progress = _progressController.value;
            final currentPosition = Duration(
              milliseconds: (widget.song.duration.inMilliseconds * progress).round(),
            );
            
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.progressBarActive,
                inactiveTrackColor: AppColors.progressBarInactive,
                thumbColor: AppColors.progressBarActive,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                trackHeight: 3,
              ),
              child: Slider(
                value: progress,
                onChanged: (value) {
                  _progressController.value = value;
                },
                onChangeEnd: (value) {
                  // TODO: Seek to position
                },
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final currentPosition = Duration(
                    milliseconds: (widget.song.duration.inMilliseconds * _progressController.value).round(),
                  );
                  return Text(
                    _formatDuration(currentPosition),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
                  );
                },
              ),
              Text(
                _formatDuration(widget.song.duration),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(bool isPlaying, bool isShuffle, int repeatMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle
        IconButton(
          icon: Icon(Icons.shuffle),
          color: isShuffle ? AppColors.primary : AppColors.playerButtonDisabled,
          iconSize: 28,
          onPressed: _toggleShuffle,
        ),
        
        // Previous
        IconButton(
          icon: const Icon(Icons.skip_previous),
          color: AppColors.playerButton,
          iconSize: 36,
          onPressed: () {
            // TODO: Previous song
          },
        ),
        
        // Play/Pause
        Container(
          decoration: BoxDecoration(
            color: AppColors.textPrimaryDark,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.playerBackground,
            ),
            iconSize: 40,
            onPressed: _togglePlayPause,
          ),
        ),
        
        // Next
        IconButton(
          icon: const Icon(Icons.skip_next),
          color: AppColors.playerButton,
          iconSize: 36,
          onPressed: () {
            // TODO: Next song
          },
        ),
        
        // Repeat
        IconButton(
          icon: Icon(
            repeatMode == 0
                ? Icons.repeat
                : repeatMode == 1
                    ? Icons.repeat
                    : Icons.repeat_one,
          ),
          color: repeatMode == 0 ? AppColors.playerButtonDisabled : AppColors.primary,
          iconSize: 28,
          onPressed: _toggleRepeat,
        ),
      ],
    );
  }

  Widget _buildActionBar(bool isVideoMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Like
        IconButton(
          icon: Icon(
            widget.song.isLiked ? Icons.favorite : Icons.favorite_border,
          ),
          color: widget.song.isLiked ? AppColors.accent : AppColors.playerButton,
          onPressed: () {
            // TODO: Toggle like
          },
        ),
        
        // Dislike
        IconButton(
          icon: const Icon(Icons.thumb_down_outlined),
          color: AppColors.playerButton,
          onPressed: () {
            // TODO: Dislike song
          },
        ),
        
        // Add to playlist
        IconButton(
          icon: const Icon(Icons.playlist_add),
          color: AppColors.playerButton,
          onPressed: () {
            // TODO: Add to playlist
          },
        ),
        
        // Share
        IconButton(
          icon: const Icon(Icons.share),
          color: AppColors.playerButton,
          onPressed: () {
            // TODO: Share song
          },
        ),
        
        // Download
        IconButton(
          icon: Icon(
            widget.song.isDownloaded ? Icons.download_done : Icons.download,
          ),
          color: widget.song.isDownloaded ? AppColors.accent : AppColors.playerButton,
          onPressed: () {
            // TODO: Download song
          },
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}