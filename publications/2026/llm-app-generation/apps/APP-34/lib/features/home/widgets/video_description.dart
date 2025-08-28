import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/video.dart';

class VideoDescription extends StatefulWidget {
  final Video video;

  const VideoDescription({
    super.key,
    required this.video,
  });

  @override
  State<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription> {
  bool _isExpanded = false;
  final int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Creator Username
        GestureDetector(
          onTap: () {
            // TODO: Navigate to creator profile
          },
          child: Row(
            children: [
              Text(
                '@${widget.video.creator.username}',
                style: AppTheme.usernameStyle,
              ),
              if (widget.video.creator.isVerified) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified,
                  color: AppConstants.secondaryColor,
                  size: 16,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Video Caption with Hashtags
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: RichText(
            maxLines: _isExpanded ? null : _maxLines,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            text: TextSpan(
              style: AppTheme.captionStyle,
              children: _buildCaptionSpans(),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Sound Information
        if (widget.video.soundName != null) ...[
          GestureDetector(
            onTap: () {
              // TODO: Navigate to sound page
            },
            child: Row(
              children: [
                const Icon(
                  Icons.music_note,
                  color: AppConstants.textPrimaryColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.video.soundName!,
                    style: AppTheme.soundNameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<TextSpan> _buildCaptionSpans() {
    final List<TextSpan> spans = [];
    final words = widget.video.caption.split(' ');

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      
      if (word.startsWith('#')) {
        // Hashtag
        spans.add(
          TextSpan(
            text: word,
            style: AppTheme.hashtagStyle,
          ),
        );
      } else if (word.startsWith('@')) {
        // Mention
        spans.add(
          TextSpan(
            text: word,
            style: AppTheme.hashtagStyle,
          ),
        );
      } else {
        // Regular text
        spans.add(
          TextSpan(
            text: word,
            style: AppTheme.captionStyle,
          ),
        );
      }

      // Add space between words (except for the last word)
      if (i < words.length - 1) {
        spans.add(
          const TextSpan(
            text: ' ',
            style: AppTheme.captionStyle,
          ),
        );
      }
    }

    return spans;
  }
}