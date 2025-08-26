import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class GameCard extends StatelessWidget {
  final Map<String, dynamic> game;

  const GameCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final isInstalled = game['isInstalled'] ?? false;
    final isDownloading = game['isDownloading'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.netflixDarkGray,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Icon
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: game['iconUrl'] ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppTheme.netflixGray,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.netflixRed,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppTheme.netflixGray,
                    child: const Center(
                      child: Icon(
                        Icons.videogame_asset,
                        color: AppTheme.netflixWhite,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Game Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game Title
                  Text(
                    game['title'] ?? 'Unknown Game',
                    style: const TextStyle(
                      color: AppTheme.netflixWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Game Category
                  Text(
                    game['category'] ?? 'Game',
                    style: const TextStyle(
                      color: AppTheme.netflixLightGray,
                      fontSize: 12,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and Size
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${game['rating'] ?? 0.0}',
                        style: const TextStyle(
                          color: AppTheme.netflixLightGray,
                          fontSize: 10,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${game['sizeInMB'] ?? 0}MB',
                        style: const TextStyle(
                          color: AppTheme.netflixLightGray,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: _buildActionButton(isInstalled, isDownloading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isInstalled, bool isDownloading) {
    if (isDownloading) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.netflixGray,
          padding: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                color: AppTheme.netflixWhite,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 8),
            Text(
              AppStrings.downloading,
              style: TextStyle(
                color: AppTheme.netflixWhite,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (isInstalled) {
      return ElevatedButton(
        onPressed: () {
          // TODO: Launch game
          _launchGame();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.netflixRed,
          padding: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: const Text(
          AppStrings.open,
          style: TextStyle(
            color: AppTheme.netflixWhite,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return OutlinedButton(
      onPressed: () {
        // TODO: Install game
        _installGame();
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.netflixWhite, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: const Text(
        AppStrings.install,
        style: TextStyle(
          color: AppTheme.netflixWhite,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _launchGame() {
    // TODO: Implement game launch logic
    print('Launching game: ${game['title']}');
  }

  void _installGame() {
    // TODO: Implement game installation logic
    print('Installing game: ${game['title']}');
  }
}