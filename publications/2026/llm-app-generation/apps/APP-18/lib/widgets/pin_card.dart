import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_theme.dart';
import '../models/pin.dart';

class PinCard extends StatelessWidget {
  final Pin pin;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onLike;
  final VoidCallback? onShare;

  const PinCard({
    super.key,
    required this.pin,
    this.onTap,
    this.onSave,
    this.onLike,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppDecorations.pinCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pin Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLarge),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: pin.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: AppTheme.grey200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: AppTheme.grey200,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppTheme.grey400,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  // Overlay with action buttons
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            AppTheme.overlayColorLight,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Save button (top right)
                  Positioned(
                    top: AppTheme.spacingSmall,
                    right: AppTheme.spacingSmall,
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMedium,
                          vertical: AppTheme.spacingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: AppTheme.fontSizeSmall,
                            fontWeight: AppTheme.fontWeightSemiBold,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Action buttons (bottom right)
                  Positioned(
                    bottom: AppTheme.spacingSmall,
                    right: AppTheme.spacingSmall,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Like button
                        GestureDetector(
                          onTap: onLike,
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.spacingSmall),
                            decoration: const BoxDecoration(
                              color: AppTheme.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              pin.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: pin.isLiked ? AppTheme.primaryColor : AppTheme.grey600,
                              size: AppTheme.iconSizeSmall,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        // Share button
                        GestureDetector(
                          onTap: onShare,
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.spacingSmall),
                            decoration: const BoxDecoration(
                              color: AppTheme.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.share_outlined,
                              color: AppTheme.grey600,
                              size: AppTheme.iconSizeSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Product price overlay (if it's a product pin)
                  if (pin.isProduct && pin.price != null)
                    Positioned(
                      bottom: AppTheme.spacingSmall,
                      left: AppTheme.spacingSmall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: Text(
                          '${pin.currency ?? '\$'}${pin.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: AppTheme.fontSizeSmall,
                            fontWeight: AppTheme.fontWeightSemiBold,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Pin content
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pin title
                  Text(
                    pin.title,
                    style: AppTextStyles.pinTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (pin.description != null && pin.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      pin.description!,
                      style: AppTextStyles.pinDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingSmall),
                  // User info and stats
                  Row(
                    children: [
                      // User avatar
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppTheme.grey300,
                        backgroundImage: pin.userProfileImageUrl != null
                            ? CachedNetworkImageProvider(pin.userProfileImageUrl!)
                            : null,
                        child: pin.userProfileImageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 16,
                                color: AppTheme.grey600,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppTheme.spacingSmall),
                      // Username
                      Expanded(
                        child: Text(
                          pin.username,
                          style: AppTextStyles.username,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Stats
                      if (pin.likesCount > 0 || pin.savesCount > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (pin.likesCount > 0) ...[
                              const Icon(
                                Icons.favorite,
                                size: 12,
                                color: AppTheme.grey500,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _formatCount(pin.likesCount),
                                style: AppTextStyles.caption,
                              ),
                            ],
                            if (pin.likesCount > 0 && pin.savesCount > 0)
                              const SizedBox(width: AppTheme.spacingSmall),
                            if (pin.savesCount > 0) ...[
                              const Icon(
                                Icons.bookmark,
                                size: 12,
                                color: AppTheme.grey500,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _formatCount(pin.savesCount),
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                  // Tags
                  if (pin.tags.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: pin.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.grey200,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}