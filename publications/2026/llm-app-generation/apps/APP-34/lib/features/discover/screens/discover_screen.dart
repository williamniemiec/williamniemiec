import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _trendingHashtags = [
    '#fyp',
    '#viral',
    '#trending',
    '#dance',
    '#comedy',
    '#music',
    '#food',
    '#travel',
    '#fashion',
    '#art',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppConstants.textPrimaryColor),
                decoration: InputDecoration(
                  hintText: 'Search users, sounds, hashtags...',
                  hintStyle: const TextStyle(color: AppConstants.textSecondaryColor),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppConstants.textSecondaryColor,
                  ),
                  filled: true,
                  fillColor: AppConstants.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                ),
                onSubmitted: (value) {
                  // TODO: Implement search functionality
                },
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trending Section
                    const Text(
                      'Trending Hashtags',
                      style: AppTheme.usernameStyle,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    // Hashtags Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: AppConstants.smallPadding,
                        mainAxisSpacing: AppConstants.smallPadding,
                      ),
                      itemCount: _trendingHashtags.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // TODO: Navigate to hashtag page
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppConstants.surfaceColor,
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                            child: Center(
                              child: Text(
                                _trendingHashtags[index],
                                style: AppTheme.hashtagStyle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppConstants.largePadding),

                    // Discover Categories
                    const Text(
                      'Discover',
                      style: AppTheme.usernameStyle,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),

                    _buildDiscoverCategory('Live', Icons.live_tv),
                    _buildDiscoverCategory('Music', Icons.music_note),
                    _buildDiscoverCategory('Comedy', Icons.sentiment_very_satisfied),
                    _buildDiscoverCategory('Gaming', Icons.sports_esports),
                    _buildDiscoverCategory('Food', Icons.restaurant),
                    _buildDiscoverCategory('Sports', Icons.sports_soccer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverCategory(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppConstants.primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppConstants.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppConstants.textSecondaryColor,
          size: 16,
        ),
        onTap: () {
          // TODO: Navigate to category page
        },
        tileColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}