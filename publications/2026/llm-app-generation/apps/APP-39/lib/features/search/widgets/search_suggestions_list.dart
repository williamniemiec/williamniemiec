import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SearchSuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final List<String> searchHistory;
  final Function(String) onSuggestionTap;
  final Function(String) onHistoryTap;
  final VoidCallback onClearHistory;

  const SearchSuggestionsList({
    super.key,
    required this.suggestions,
    required this.searchHistory,
    required this.onSuggestionTap,
    required this.onHistoryTap,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        // Search History Section
        if (searchHistory.isNotEmpty) ...[
          Row(
            children: [
              Text(
                'Recent searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearHistory,
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...searchHistory.take(5).map((query) => _buildHistoryItem(
            context,
            query,
            () => onHistoryTap(query),
          )),
          const SizedBox(height: AppConstants.defaultPadding),
          const Divider(),
          const SizedBox(height: AppConstants.defaultPadding),
        ],

        // Suggestions Section
        if (suggestions.isNotEmpty) ...[
          Text(
            'Suggestions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...suggestions.map((suggestion) => _buildSuggestionItem(
            context,
            suggestion,
            () => onSuggestionTap(suggestion),
          )),
        ],

        // Trending Searches
        if (suggestions.isEmpty && searchHistory.isEmpty) ...[
          Text(
            'Trending searches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ..._getTrendingSearches().map((trending) => _buildSuggestionItem(
            context,
            trending,
            () => onSuggestionTap(trending),
          )),
        ],
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, String query, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(
        Icons.history,
        color: AppTheme.textSecondary,
        size: 20,
      ),
      title: Text(
        query,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      trailing: IconButton(
        onPressed: () {
          // Remove individual history item
        },
        icon: const Icon(
          Icons.close,
          color: AppTheme.textTertiary,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String suggestion, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(
        Icons.search,
        color: AppTheme.textSecondary,
        size: 20,
      ),
      title: Text(
        suggestion,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      trailing: IconButton(
        onPressed: () {
          // Fill search bar with suggestion
        },
        icon: const Icon(
          Icons.north_west,
          color: AppTheme.textTertiary,
          size: 16,
        ),
      ),
    );
  }

  List<String> _getTrendingSearches() {
    return [
      'Flutter development',
      'Google I/O 2024',
      'AI and machine learning',
      'Climate change solutions',
      'Space exploration',
      'Healthy recipes',
      'Travel destinations',
      'Technology news',
      'Sports updates',
      'Movie reviews',
    ];
  }
}