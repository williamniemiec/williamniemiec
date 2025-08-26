import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/content.dart';

class ContentGridItem extends StatelessWidget {
  final Content content;
  final VoidCallback onTap;

  const ContentGridItem({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 8),
                    _buildTitle(),
                    const SizedBox(height: 4),
                    _buildSubtitle(),
                    const Spacer(),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
      ),
      child: Stack(
        children: [
          // Thumbnail image
          content.thumbnailUrl != null && content.thumbnailUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: content.thumbnailUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
          
          // Content type indicator
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getContentTypeIcon(),
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    content.durationDisplay,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Featured badge
          if (content.isFeatured)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.3),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getContentTypeIcon(),
          size: 32,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content.difficultyDisplay.toUpperCase(),
            style: TextStyle(
              color: _getDifficultyColor(),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        if (content.rating > 0) ...[
          Icon(
            Icons.star,
            size: 12,
            color: Colors.amber,
          ),
          const SizedBox(width: 2),
          Text(
            content.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      content.title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      content.partner,
      style: TextStyle(
        fontSize: 12,
        color: AppTheme.textSecondary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Text(
            content.categoryDisplay.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        const Spacer(),
        if (content.viewCount > 0)
          Text(
            '${_formatViewCount(content.viewCount)} views',
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textLight,
            ),
          ),
      ],
    );
  }

  IconData _getContentTypeIcon() {
    switch (content.type) {
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.audio:
        return Icons.headphones;
      case ContentType.article:
        return Icons.article_outlined;
      case ContentType.recipe:
        return Icons.restaurant_menu;
    }
  }

  Color _getDifficultyColor() {
    switch (content.difficulty) {
      case DifficultyLevel.beginner:
        return AppTheme.successColor;
      case DifficultyLevel.intermediate:
        return AppTheme.warningColor;
      case DifficultyLevel.advanced:
        return AppTheme.errorColor;
    }
  }

  String _formatViewCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}