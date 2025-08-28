import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/property.dart';
import '../../../shared/models/search.dart';
import '../widgets/property_card.dart';
import '../widgets/search_filters_sheet.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Property> _properties = [];
  SearchResult? _searchResult;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _performSearch();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreResults();
    }
  }

  Future<void> _performSearch({int page = 1}) async {
    final appProvider = context.read<AppProvider>();
    final criteria = appProvider.currentSearchCriteria;
    
    if (criteria == null) {
      Navigator.of(context).pop();
      return;
    }

    if (page == 1) {
      setState(() {
        _isLoading = true;
        _properties.clear();
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final result = await appProvider.propertyService.searchProperties(
        criteria,
        page: page,
      );

      setState(() {
        _searchResult = result;
        if (page == 1) {
          _properties = List<Property>.from(result.results);
        } else {
          _properties.addAll(List<Property>.from(result.results));
        }
        _currentPage = page;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreResults() async {
    if (_isLoadingMore || _searchResult == null || !_searchResult!.hasMore) {
      return;
    }

    await _performSearch(page: _currentPage + 1);
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFiltersSheet(
        currentFilters: context.read<AppProvider>().currentSearchCriteria?.filters ?? const SearchFilters(),
        onFiltersApplied: (filters) {
          final appProvider = context.read<AppProvider>();
          final currentCriteria = appProvider.currentSearchCriteria;
          if (currentCriteria != null) {
            final newCriteria = currentCriteria.copyWith(filters: filters);
            appProvider.updateSearchCriteria(newCriteria);
            _performSearch();
          }
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Recommended', 'recommended'),
            _buildSortOption('Price (low to high)', 'price_low'),
            _buildSortOption('Price (high to low)', 'price_high'),
            _buildSortOption('Guest rating', 'rating'),
            _buildSortOption('Distance', 'distance'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final appProvider = context.read<AppProvider>();
    final currentSort = appProvider.currentSearchCriteria?.filters.sortBy ?? 'recommended';
    final isSelected = currentSort == value;

    return ListTile(
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primaryBlue) : null,
      onTap: () {
        final currentCriteria = appProvider.currentSearchCriteria;
        if (currentCriteria != null) {
          final newFilters = currentCriteria.filters.copyWith(sortBy: value);
          final newCriteria = currentCriteria.copyWith(filters: newFilters);
          appProvider.updateSearchCriteria(newCriteria);
          _performSearch();
        }
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            final criteria = appProvider.currentSearchCriteria;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  criteria?.destination ?? 'Search Results',
                  style: const TextStyle(fontSize: 18),
                ),
                if (criteria != null)
                  Text(
                    '${criteria.numberOfNights} nights • ${criteria.numberOfGuests} guests',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              // TODO: Show map view
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Sort Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppTheme.lightGrey),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showFilters,
                    icon: const Icon(Icons.tune),
                    label: Consumer<AppProvider>(
                      builder: (context, appProvider, child) {
                        final filters = appProvider.currentSearchCriteria?.filters;
                        final activeCount = filters?.activeFilterCount ?? 0;
                        return Text(
                          activeCount > 0 ? 'Filters ($activeCount)' : 'Filters',
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showSortOptions,
                    icon: const Icon(Icons.sort),
                    label: const Text('Sort'),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _properties.isEmpty
                    ? _buildEmptyState()
                    : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.mediumGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Modify Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        // Results count
        if (_searchResult != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppTheme.lightGrey,
            child: Text(
              '${_searchResult!.totalCount} properties found',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Properties list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _properties.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _properties.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final property = _properties[index];
              return PropertyCard(
                property: property,
                onTap: () {
                  // TODO: Navigate to property details
                },
              );
            },
          ),
        ),
      ],
    );
  }
}