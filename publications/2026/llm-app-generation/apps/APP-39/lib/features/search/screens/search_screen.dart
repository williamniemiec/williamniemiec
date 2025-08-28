import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/search_results_list.dart';
import '../widgets/search_suggestions_list.dart';
import '../widgets/ai_overview_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late TabController _tabController;

  final List<String> _filterTabs = [
    'All',
    'Images',
    'Videos',
    'News',
    'Shopping',
    'Maps',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();
    _tabController = TabController(length: _filterTabs.length, vsync: this);

    // Auto-focus search bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    // Perform initial search if query provided
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppProvider>().search(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  
                  // Search Input
                  Expanded(
                    child: Container(
                      height: AppConstants.searchBarHeight,
                      decoration: BoxDecoration(
                        color: AppTheme.searchBarColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.searchBarHeight / 2,
                        ),
                        border: Border.all(
                          color: AppTheme.searchBarBorderColor,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search Google or type a URL',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                            vertical: AppConstants.defaultPadding,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<AppProvider>().getSearchSuggestions('');
                                  },
                                  icon: const Icon(Icons.clear, size: 20),
                                ),
                              IconButton(
                                onPressed: _showVoiceSearch,
                                icon: const Icon(Icons.mic, size: 20),
                              ),
                              IconButton(
                                onPressed: _openLens,
                                icon: const Icon(Icons.camera_alt, size: 20),
                              ),
                            ],
                          ),
                        ),
                        onChanged: (query) {
                          context.read<AppProvider>().getSearchSuggestions(query);
                        },
                        onSubmitted: (query) {
                          if (query.trim().isNotEmpty) {
                            context.read<AppProvider>().search(query);
                            _searchFocusNode.unfocus();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  // Show suggestions when focused and no search results
                  if (_searchFocusNode.hasFocus && 
                      appProvider.searchResults.isEmpty &&
                      !appProvider.isSearching) {
                    return SearchSuggestionsList(
                      suggestions: appProvider.searchSuggestions,
                      searchHistory: appProvider.searchHistory,
                      onSuggestionTap: (suggestion) {
                        _searchController.text = suggestion;
                        appProvider.search(suggestion);
                        _searchFocusNode.unfocus();
                      },
                      onHistoryTap: (query) {
                        _searchController.text = query;
                        appProvider.search(query);
                        _searchFocusNode.unfocus();
                      },
                      onClearHistory: () {
                        appProvider.clearSearchHistory();
                      },
                    );
                  }

                  // Show loading
                  if (appProvider.isSearching) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Show search results
                  if (appProvider.searchResults.isNotEmpty) {
                    return Column(
                      children: [
                        // Filter Tabs
                        Container(
                          height: 48,
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: AppTheme.primaryBlue,
                            unselectedLabelColor: AppTheme.textSecondary,
                            indicatorColor: AppTheme.primaryBlue,
                            tabs: _filterTabs.map((tab) => Tab(text: tab)).toList(),
                          ),
                        ),
                        
                        // Results
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: _filterTabs.map((tab) {
                              return SearchResultsList(
                                results: appProvider.searchResults,
                                query: appProvider.currentQuery,
                                showAIOverview: tab == 'All',
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }

                  // Empty state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Text(
                          'Search Google',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          'Find information, images, videos and more',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceSearch() {
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

  void _openLens() {
    // Navigate to Lens screen
    Navigator.pushNamed(context, '/lens');
  }
}