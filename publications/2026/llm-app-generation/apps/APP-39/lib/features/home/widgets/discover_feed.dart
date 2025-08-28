import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/discover_article.dart';

class DiscoverFeed extends StatelessWidget {
  const DiscoverFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final articles = appProvider.discoverArticles;

        if (articles.isEmpty && !appProvider.isLoadingDiscover) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'No articles available',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Pull to refresh or check your internet connection',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                // Discover header
                return Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      Text(
                        'Discover',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (appProvider.currentUser != null)
                        IconButton(
                          onPressed: () => _showCustomizeDialog(context),
                          icon: const Icon(Icons.tune),
                          tooltip: 'Customize feed',
                        ),
                    ],
                  ),
                );
              }

              final articleIndex = index - 1;
              if (articleIndex >= articles.length) return null;

              final article = articles[articleIndex];
              return DiscoverArticleCard(
                article: article,
                onTap: () => _openArticle(article),
                onBookmark: () => appProvider.toggleArticleBookmark(article.id),
                onShare: () => _shareArticle(article),
                onMoreOptions: () => _showMoreOptions(context, article),
              );
            },
            childCount: articles.length + 1, // +1 for header
          ),
        );
      },
    );
  }

  void _openArticle(DiscoverArticle article) async {
    final uri = Uri.parse(article.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareArticle(DiscoverArticle article) {
    // In a real app, you would use share_plus package
    // Share.share('${article.title}\n${article.url}');
  }

  void _showCustomizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customize your feed'),
        content: const Text('Feature coming soon! You\'ll be able to follow topics and customize your Discover feed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, DiscoverArticle article) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: const Text('Not interested'),
              onTap: () {
                Navigator.pop(context);
                // Hide article logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: Text('Don\'t show content from ${article.source}'),
              onTap: () {
                Navigator.pop(context);
                // Block source logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Report content'),
              onTap: () {
                Navigator.pop(context);
                // Report content logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverArticleCard extends StatelessWidget {
  final DiscoverArticle article;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onMoreOptions;

  const DiscoverArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.borderRadius),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppTheme.surfaceColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: AppTheme.surfaceColor,
                    child: const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),

            // Article Content
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Time
                  Row(
                    children: [
                      if (article.sourceIcon != null)
                        CachedNetworkImage(
                          imageUrl: article.sourceIcon!,
                          width: 16,
                          height: 16,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.public,
                            size: 16,
                          ),
                        ),
                      if (article.sourceIcon != null)
                        const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        article.source,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        article.timeAgo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.smallPadding),

                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),

                  // Description
                  Text(
                    article.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Action Buttons
                  Row(
                    children: [
                      // Topics
                      if (article.topics.isNotEmpty)
                        Expanded(
                          child: Wrap(
                            spacing: AppConstants.smallPadding,
                            children: article.topics.take(2).map((topic) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.smallPadding,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  topic,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryBlue,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      // Action Icons
                      IconButton(
                        onPressed: onBookmark,
                        icon: Icon(
                          article.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: article.isBookmarked
                              ? AppTheme.primaryBlue
                              : AppTheme.textSecondary,
                        ),
                        tooltip: article.isBookmarked ? 'Remove bookmark' : 'Bookmark',
                      ),
                      IconButton(
                        onPressed: onShare,
                        icon: const Icon(Icons.share),
                        color: AppTheme.textSecondary,
                        tooltip: 'Share',
                      ),
                      IconButton(
                        onPressed: onMoreOptions,
                        icon: const Icon(Icons.more_vert),
                        color: AppTheme.textSecondary,
                        tooltip: 'More options',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}