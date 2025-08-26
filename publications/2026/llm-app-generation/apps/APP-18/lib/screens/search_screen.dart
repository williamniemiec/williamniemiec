import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<String> _searchHistory = [];
  List<String> _trendingTopics = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _loadTrendingTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadSearchHistory() {
    // Load search history from storage
    setState(() {
      _searchHistory = [
        'home decor',
        'fashion inspiration',
        'healthy recipes',
        'travel destinations',
        'diy crafts',
      ];
    });
  }

  void _loadTrendingTopics() {
    // Load trending topics
    setState(() {
      _trendingTopics = [
        'Christmas decorations',
        'Winter fashion',
        'Holiday recipes',
        'New Year party ideas',
        'Cozy home vibes',
        'Minimalist design',
        'Plant care tips',
        'Workout routines',
      ];
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      // Add to search history
      setState(() {
        _searchHistory.remove(query);
        _searchHistory.insert(0, query);
        if (_searchHistory.length > AppConstants.maxSearchHistoryItems) {
          _searchHistory.removeLast();
        }
      });
      
      // Navigate to search results
      Navigator.pushNamed(
        context,
        '/search_results',
        arguments: query,
      );
    }
  }

  void _onTrendingTopicTap(String topic) {
    _searchController.text = topic;
    _onSearchSubmitted(topic);
  }

  void _onHistoryItemTap(String query) {
    _searchController.text = query;
    _onSearchSubmitted(query);
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _openVisualSearch() {
    Navigator.pushNamed(context, '/visual_search');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Search',
        actions: [
          IconButton(
            onPressed: _openVisualSearch,
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'Visual Search',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                hintText: 'Search for ideas',
                hintStyle: AppTextStyles.searchHint,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.grey500,
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                          _searchFocusNode.unfocus();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: AppTheme.grey500,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.grey100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacingMedium,
                ),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: _isSearching
                ? _buildSearchSuggestions()
                : _buildDiscoverContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
      children: [
        // Search suggestions would go here
        const Center(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingXLarge),
            child: Text(
              'Search suggestions will appear here',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: AppTheme.fontSizeMedium,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
      children: [
        // Search History
        if (_searchHistory.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent searches',
                style: TextStyle(
                  fontSize: AppTheme.fontSizeLarge,
                  fontWeight: AppTheme.fontWeightSemiBold,
                  color: AppTheme.textPrimary,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              TextButton(
                onPressed: _clearSearchHistory,
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: AppTheme.fontSizeSmall,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          ...(_searchHistory.map((query) => ListTile(
                leading: const Icon(
                  Icons.history,
                  color: AppTheme.grey500,
                ),
                title: Text(
                  query,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeMedium,
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _searchHistory.remove(query);
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppTheme.grey400,
                    size: 20,
                  ),
                ),
                onTap: () => _onHistoryItemTap(query),
              ))),
          const SizedBox(height: AppTheme.spacingLarge),
        ],
        
        // Trending Topics
        const Text(
          'Trending now',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLarge,
            fontWeight: AppTheme.fontWeightSemiBold,
            color: AppTheme.textPrimary,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppTheme.spacingSmall,
            mainAxisSpacing: AppTheme.spacingSmall,
            childAspectRatio: 2.5,
          ),
          itemCount: _trendingTopics.length,
          itemBuilder: (context, index) {
            final topic = _trendingTopics[index];
            return GestureDetector(
              onTap: () => _onTrendingTopicTap(topic),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.8),
                      AppTheme.primaryColorLight.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: Center(
                  child: Text(
                    topic,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: AppTheme.fontSizeMedium,
                      fontWeight: AppTheme.fontWeightSemiBold,
                      fontFamily: AppTheme.fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: AppTheme.spacingLarge),
        
        // Categories
        const Text(
          'Browse categories',
          style: TextStyle(
            fontSize: AppTheme.fontSizeLarge,
            fontWeight: AppTheme.fontWeightSemiBold,
            color: AppTheme.textPrimary,
            fontFamily: AppTheme.fontFamily,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        _buildCategoriesGrid(),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {'name': 'Home Decor', 'icon': Icons.home_outlined, 'color': AppTheme.accentBlue},
      {'name': 'Fashion', 'icon': Icons.checkroom_outlined, 'color': AppTheme.accentPurple},
      {'name': 'Food & Drink', 'icon': Icons.restaurant_outlined, 'color': AppTheme.accentOrange},
      {'name': 'Travel', 'icon': Icons.flight_outlined, 'color': AppTheme.accentTeal},
      {'name': 'DIY & Crafts', 'icon': Icons.build_outlined, 'color': AppTheme.accentGreen},
      {'name': 'Beauty', 'icon': Icons.face_outlined, 'color': AppTheme.primaryColor},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacingSmall,
        mainAxisSpacing: AppTheme.spacingSmall,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => _onTrendingTopicTap(category['name'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: AppTheme.elevationSmall,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  category['name'] as String,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight: AppTheme.fontWeightMedium,
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}