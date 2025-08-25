import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/coloring_page.dart';
import '../providers/library_provider.dart';
import '../constants/app_constants.dart';

class ColoringPageCard extends StatelessWidget {
  final ColoringPage page;
  final VoidCallback onTap;
  final bool showProgress;
  final bool compact;

  const ColoringPageCard({
    super.key,
    required this.page,
    required this.onTap,
    this.showProgress = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, child) {
        final progress = libraryProvider.getProgressPercentage(page.id);
        final isCompleted = libraryProvider.isPageCompleted(page.id);
        final isInProgress = libraryProvider.isPageInProgress(page.id);
        final isFavorite = libraryProvider.isFavorite(page.id);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Container
                Expanded(
                  flex: compact ? 3 : 4,
                  child: Stack(
                    children: [
                      // Thumbnail Image
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppConstants.radiusMedium),
                          ),
                          color: AppConstants.backgroundColor,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppConstants.radiusMedium),
                          ),
                          child: _buildThumbnail(),
                        ),
                      ),

                      // Status Badges
                      Positioned(
                        top: AppConstants.paddingSmall,
                        right: AppConstants.paddingSmall,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (page.isPremium)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.accentColor,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                ),
                                child: Text(
                                  'PRO',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            if (page.isPremium) const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => libraryProvider.toggleFavorite(page.id),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? AppConstants.accentColor : AppConstants.textSecondary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Completion Badge
                      if (isCompleted)
                        Positioned(
                          top: AppConstants.paddingSmall,
                          left: AppConstants.paddingSmall,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppConstants.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),

                      // Progress Overlay
                      if (showProgress && isInProgress)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(AppConstants.radiusMedium),
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryColor,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(AppConstants.radiusMedium),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  flex: compact ? 2 : 3,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        if (!compact) ...[
                          const SizedBox(height: 4),
                          
                          // Category and Difficulty
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  page.category,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppConstants.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildDifficultyIndicator(context),
                            ],
                          ),
                        ],

                        const Spacer(),

                        // Progress Text
                        if (showProgress && (isInProgress || isCompleted))
                          Text(
                            isCompleted 
                                ? 'Completed' 
                                : '${progress.toInt()}% complete',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isCompleted 
                                  ? AppConstants.secondaryColor 
                                  : AppConstants.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThumbnail() {
    // In a real app, you would load the actual thumbnail image
    // For now, we'll show a placeholder with the page title
    return Container(
      color: AppConstants.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(),
              size: 48,
              color: AppConstants.primaryColor.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              page.title,
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (page.category.toLowerCase()) {
      case 'animals':
        return Icons.pets;
      case 'mandalas':
        return Icons.filter_vintage;
      case 'floral':
        return Icons.local_florist;
      case 'nature':
        return Icons.nature;
      case 'fantasy':
        return Icons.auto_awesome;
      case 'famous paintings':
        return Icons.museum;
      case 'abstract':
        return Icons.brush;
      case 'geometric':
        return Icons.category;
      default:
        return Icons.palette;
    }
  }

  Widget _buildDifficultyIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        return Icon(
          Icons.star,
          size: 12,
          color: index < page.difficulty 
              ? AppConstants.accentColor 
              : AppConstants.textLight,
        );
      }),
    );
  }
}