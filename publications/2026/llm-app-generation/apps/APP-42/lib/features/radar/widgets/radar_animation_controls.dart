import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RadarAnimationControls extends StatelessWidget {
  final bool isAnimating;
  final int currentFrame;
  final int totalFrames;
  final VoidCallback onToggleAnimation;
  final ValueChanged<int> onFrameChanged;

  const RadarAnimationControls({
    super.key,
    required this.isAnimating,
    required this.currentFrame,
    required this.totalFrames,
    required this.onToggleAnimation,
    required this.onFrameChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalFrames == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timeline slider
          Row(
            children: [
              Text(
                'Frame',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.primaryBlue,
                    inactiveTrackColor: AppTheme.primaryBlue.withOpacity(0.3),
                    thumbColor: AppTheme.primaryBlue,
                    overlayColor: AppTheme.primaryBlue.withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: currentFrame.toDouble(),
                    min: 0,
                    max: (totalFrames - 1).toDouble(),
                    divisions: totalFrames - 1,
                    onChanged: isAnimating ? null : (value) {
                      onFrameChanged(value.round());
                    },
                  ),
                ),
              ),
              Text(
                '${currentFrame + 1}/$totalFrames',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous frame
              IconButton(
                onPressed: isAnimating || currentFrame == 0 ? null : () {
                  onFrameChanged(currentFrame - 1);
                },
                icon: const Icon(Icons.skip_previous),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                  foregroundColor: AppTheme.primaryBlue,
                ),
              ),
              
              // Play/Pause
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  onPressed: onToggleAnimation,
                  icon: Icon(
                    isAnimating ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 28,
                ),
              ),
              
              // Next frame
              IconButton(
                onPressed: isAnimating || currentFrame == totalFrames - 1 ? null : () {
                  onFrameChanged(currentFrame + 1);
                },
                icon: const Icon(Icons.skip_next),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                  foregroundColor: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Time indicator
          Text(
            _getTimeLabel(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeLabel() {
    if (totalFrames == 0) return '';
    
    // Assuming each frame represents 5 minutes in the past
    final minutesAgo = (totalFrames - 1 - currentFrame) * 5;
    
    if (minutesAgo == 0) {
      return 'Now';
    } else if (minutesAgo < 60) {
      return '${minutesAgo}m ago';
    } else {
      final hoursAgo = minutesAgo ~/ 60;
      final remainingMinutes = minutesAgo % 60;
      if (remainingMinutes == 0) {
        return '${hoursAgo}h ago';
      } else {
        return '${hoursAgo}h ${remainingMinutes}m ago';
      }
    }
  }
}