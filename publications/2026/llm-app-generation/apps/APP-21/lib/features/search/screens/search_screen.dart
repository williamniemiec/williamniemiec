import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for search results
final searchResultsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Provider for search history
final searchHistoryProvider = StateProvider<List<String>>((ref) => []);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(searchQueryProvider.notifier).state = query;
    
    if (query.isNotEmpty) {
      // Simulate search results
      _performSearch(query);
    } else {
      ref.read(searchResultsProvider.notifier).state = [];
    }
  }

  void _performSearch(String query) {
    // Mock search implementation
    final mockResults = _getMockSearchResults(query);
    ref.read(searchResultsProvider.notifier).state = mockResults;
  }

  void _addToSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    
    final history = ref.read(searchHistoryProvider);
    final updatedHistory = [query, ...history.where((item) => item != query)]
        .take(AppConstants.maxSearchHistoryItems)
        .toList();
    
    ref.read(searchHistoryProvider.notifier).state = updatedHistory;
  }

  void _clearSearchHistory() {
    ref.read(searchHistoryProvider.notifier).state = [];
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final searchHistory = ref.watch(searchHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: TextStyle(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  hintText: 'Search songs, artists, albums...',
                  hintStyle: TextStyle(color: AppColors.textTertiaryDark),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondaryDark,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textSecondaryDark,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    _addToSearchHistory(query.trim());
                    _performSearch(query.trim());
                  }
                },
              ),
            ),

            // Content
            Expanded(
              child: searchQuery.isEmpty
                  ? _buildSearchHome(searchHistory)
                  : searchResults.isEmpty
                      ? _buildNoResults()
                      : _buildSearchResults(searchResults),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHome(List<String> searchHistory) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent searches',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearSearchHistory,
                  child: Text(
                    'Clear all',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...searchHistory.map((query) => _buildSearchHistoryItem(query)),
            const SizedBox(height: 32),
          ],

          // Browse Categories
          Text(
            'Browse all',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildBrowseGrid(),
        ],
      ),
    );
  }

  Widget _buildSearchHistoryItem(String query) {
    return ListTile(
      leading: Icon(
        Icons.history,
        color: AppColors.textSecondaryDark,
      ),
      title: Text(
        query,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.close,
          color: AppColors.textSecondaryDark,
        ),
        onPressed: () {
          final history = ref.read(searchHistoryProvider);
          final updatedHistory = history.where((item) => item != query).toList();
          ref.read(searchHistoryProvider.notifier).state = updatedHistory;
        },
      ),
      onTap: () {
        _searchController.text = query;
        _performSearch(query);
      },
    );
  }

  Widget _buildBrowseGrid() {
    final categories = [
      ...AppConstants.musicCategories.map((genre) => {
        'title': genre,
        'color': AppColors.genreColors[genre] ?? AppColors.primary,
        'type': 'genre',
      }),
      ...AppConstants.moodCategories.map((mood) => {
        'title': mood,
        'color': AppColors.moodColors[mood] ?? AppColors.secondary,
        'type': 'mood',
      }),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildBrowseCard(category);
      },
    );
  }

  Widget _buildBrowseCard(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        color: (category['color'] as Color).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (category['color'] as Color).withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to category
            _searchController.text = category['title'] as String;
            _performSearch(category['title'] as String);
          },
          child: Center(
            child: Text(
              category['title'] as String,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: category['color'] as Color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildSearchResultItem(result);
      },
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    final type = result['type'] as String;
    IconData icon;
    
    switch (type) {
      case 'song':
        icon = Icons.music_note;
        break;
      case 'artist':
        icon = Icons.person;
        break;
      case 'album':
        icon = Icons.album;
        break;
      case 'playlist':
        icon = Icons.playlist_play;
        break;
      default:
        icon = Icons.music_note;
    }

    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(type == 'artist' ? 28 : 8),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        result['title'] as String,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      subtitle: Text(
        result['subtitle'] as String,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.textSecondaryDark,
        onPressed: () {
          // TODO: Show options menu
        },
      ),
      onTap: () {
        // TODO: Handle result tap based on type
        _addToSearchHistory(_searchController.text);
      },
    );
  }

  List<Map<String, dynamic>> _getMockSearchResults(String query) {
    // Mock search results based on query
    final results = <Map<String, dynamic>>[];
    
    // Add some mock songs
    results.addAll([
      {
        'type': 'song',
        'title': 'Song matching "$query"',
        'subtitle': 'Artist Name • Album Name',
      },
      {
        'type': 'song',
        'title': 'Another song with "$query"',
        'subtitle': 'Different Artist • Different Album',
      },
    ]);

    // Add some mock artists
    results.addAll([
      {
        'type': 'artist',
        'title': 'Artist "$query"',
        'subtitle': 'Artist • 1.2M followers',
      },
    ]);

    // Add some mock albums
    results.addAll([
      {
        'type': 'album',
        'title': 'Album containing "$query"',
        'subtitle': 'Artist Name • 2023',
      },
    ]);

    // Add some mock playlists
    results.addAll([
      {
        'type': 'playlist',
        'title': 'Playlist: "$query" Mix',
        'subtitle': 'YouTube Music • 50 songs',
      },
    ]);

    return results;
  }
}