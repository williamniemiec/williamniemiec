import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class FeaturedContent extends StatelessWidget {
  const FeaturedContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final featuredHeight = screenHeight * 0.6;

    return Container(
      height: featuredHeight,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: 'https://via.placeholder.com/1280x720/333333/FFFFFF?text=Featured+Content',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.netflixDarkGray,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.netflixRed,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.netflixDarkGray,
                child: const Center(
                  child: Icon(
                    Icons.error,
                    color: AppTheme.netflixWhite,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppTheme.netflixBlack.withOpacity(0.7),
                    AppTheme.netflixBlack,
                  ],
                  stops: const [0.0, 0.5, 0.8, 1.0],
                ),
              ),
            ),
          ),
          
          // Content Information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Netflix Original Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.netflixRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NETFLIX ORIGINAL',
                      style: TextStyle(
                        color: AppTheme.netflixWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Title
                  const Text(
                    'Stranger Things',
                    style: NetflixTextStyles.heroTitle,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  const Text(
                    'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.',
                    style: TextStyle(
                      color: AppTheme.netflixOffWhite,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action Buttons
                  Row(
                    children: [
                      // Play Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Play content
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: AppTheme.netflixBlack,
                          ),
                          label: const Text(
                            AppStrings.play,
                            style: TextStyle(
                              color: AppTheme.netflixBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.netflixWhite,
                            foregroundColor: AppTheme.netflixBlack,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // My List Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Add to My List
                          },
                          icon: const Icon(
                            Icons.add,
                            color: AppTheme.netflixWhite,
                          ),
                          label: const Text(
                            AppStrings.myList,
                            style: TextStyle(
                              color: AppTheme.netflixWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppTheme.netflixWhite,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Info Button
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Show content details
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: AppTheme.netflixWhite,
                      size: 20,
                    ),
                    label: const Text(
                      AppStrings.info,
                      style: TextStyle(
                        color: AppTheme.netflixWhite,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}