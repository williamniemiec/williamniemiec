import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class ContentCarousel extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> contentList;

  const ContentCarousel({
    super.key,
    required this.title,
    required this.contentList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Text(
            title,
            style: NetflixTextStyles.sectionTitle,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Content List
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            itemCount: contentList.length,
            itemBuilder: (context, index) {
              final content = contentList[index];
              final isFirst = index == 0;
              final isLast = index == contentList.length - 1;
              
              return Padding(
                padding: EdgeInsets.only(
                  right: isLast ? 0 : 8,
                ),
                child: ContentPosterCard(
                  content: content,
                  width: 110,
                  height: 160,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ContentPosterCard extends StatelessWidget {
  final Map<String, dynamic> content;
  final double width;
  final double height;

  const ContentPosterCard({
    super.key,
    required this.content,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to content details
        _showContentDetails(context);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          child: Stack(
            children: [
              // Poster Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: content['posterUrl'] ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppTheme.netflixDarkGray,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.netflixRed,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppTheme.netflixDarkGray,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.movie,
                          color: AppTheme.netflixWhite,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content['title'] ?? 'Content',
                          style: const TextStyle(
                            color: AppTheme.netflixWhite,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content Type Badge
              if (content['type'] == 'series')
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.netflixRed,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'SERIES',
                      style: TextStyle(
                        color: AppTheme.netflixWhite,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              
              // Gradient Overlay for better text visibility
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContentDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.netflixDarkGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => ContentPreviewSheet(content: content),
    );
  }
}

class ContentPreviewSheet extends StatelessWidget {
  final Map<String, dynamic> content;

  const ContentPreviewSheet({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.netflixLightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Content Title
          Text(
            content['title'] ?? 'Unknown Title',
            style: NetflixTextStyles.sectionTitle,
          ),
          
          const SizedBox(height: 8),
          
          // Content Type and Year
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.netflixRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  content['type']?.toUpperCase() ?? 'MOVIE',
                  style: const TextStyle(
                    color: AppTheme.netflixWhite,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '2023',
                style: NetflixTextStyles.contentSubtitle,
              ),
              const SizedBox(width: 12),
              const Text(
                'TV-MA',
                style: NetflixTextStyles.contentSubtitle,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Play content
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(AppStrings.play),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Add to My List
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(AppStrings.myList),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // More Info Button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to full content details
              },
              icon: const Icon(Icons.info_outline),
              label: const Text(AppStrings.info),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}