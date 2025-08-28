import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../search/screens/search_screen.dart';
import '../../lens/screens/lens_screen.dart';

class GoogleSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String? hintText;
  final bool enabled;

  const GoogleSearchBar({
    super.key,
    this.onTap,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? (onTap ?? () => _navigateToSearch(context)) : null,
      child: Container(
        height: AppConstants.searchBarHeight,
        decoration: BoxDecoration(
          color: AppTheme.searchBarColor,
          borderRadius: BorderRadius.circular(AppConstants.searchBarHeight / 2),
          border: Border.all(
            color: AppTheme.searchBarBorderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Search Icon
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Icon(
                Icons.search,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
            
            // Search Text
            Expanded(
              child: Text(
                hintText ?? 'Search Google or type a URL',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            
            // Voice Search Icon
            GestureDetector(
              onTap: () => _showVoiceSearch(context),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                child: const Icon(
                  Icons.mic,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ),
            
            // Google Lens Icon
            GestureDetector(
              onTap: () => _navigateToLens(context),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                margin: const EdgeInsets.only(right: AppConstants.smallPadding),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
  }

  void _navigateToLens(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LensScreen(),
      ),
    );
  }

  void _showVoiceSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryRed.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.mic,
                color: AppTheme.primaryRed,
                size: 40,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Listening...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Try saying something',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}