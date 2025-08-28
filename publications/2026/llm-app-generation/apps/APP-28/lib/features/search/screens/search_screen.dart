import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/photo.dart';
import '../../photos/widgets/photo_grid_item.dart';
import '../../photo_viewer/screens/photo_viewer_screen.dart';
import '../widgets/search_categories.dart';
import '../widgets/search_suggestions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Photo> _searchResults = [];
  bool _isSearching = false;
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: AppConstants.searchPlaceholder,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: _startVoiceSearch,
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (_isSearching) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_currentQuery.isNotEmpty) {
            return _buildSearchResults();
          }

          return _buildSearchHome(provider);
        },
      ),
    );
  }

  Widget _buildSearchHome(AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search suggestions
          SearchSuggestions(
            onSuggestionTap: _onSuggestionTap,
          ),
          
          const SizedBox(height: 24),
          
          // Search categories
          SearchCategories(
            photos: provider.photos,
            onCategoryTap: _onCategoryTap,
          ),
          
          const SizedBox(height: 24),
          
          // Recent searches (if any)
          _buildRecentSearches(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.noSearchResultsMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for something else',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${_searchResults.length} result${_searchResults.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _showFilterOptions,
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
              ),
            ],
          ),
        ),
        
        // Results grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MasonryGridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: AppConstants.gridSpacing,
              crossAxisSpacing: AppConstants.gridSpacing,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final photo = _searchResults[index];
                return PhotoGridItem(
                  photo: photo,
                  onTap: () => _openPhoto(photo, index),
                  onLongPress: () => _showPhotoOptions(photo),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearches() {
    // For demo purposes, we'll show some sample recent searches
    final recentSearches = ['sunset', 'beach', 'family', 'vacation'];
    
    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent searches',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _clearRecentSearches,
              child: const Text('Clear all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: recentSearches.map((search) {
            return InputChip(
              label: Text(search),
              onPressed: () => _onSuggestionTap(search),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeRecentSearch(search),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
    });
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Debounce search
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchController.text == query) {
        _performSearch(query);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _performSearch(query);
      _addToRecentSearches(query);
    }
  }

  void _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final results = provider.searchPhotos(query);
      
      setState(() {
        _searchResults = results;
        _currentQuery = query;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _currentQuery = '';
      _searchResults = [];
    });
  }

  void _startVoiceSearch() {
    // TODO: Implement voice search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice search not implemented yet')),
    );
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
    _addToRecentSearches(suggestion);
  }

  void _onCategoryTap(String category, List<Photo> photos) {
    setState(() {
      _currentQuery = category;
      _searchResults = photos;
    });
    _searchController.text = category;
  }

  void _openPhoto(Photo photo, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photo: photo,
          photos: _searchResults,
          initialIndex: index,
          title: 'Search results',
        ),
      ),
    );
  }

  void _showPhotoOptions(Photo photo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              photo.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            title: Text(photo.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
            onTap: () {
              Navigator.pop(context);
              Provider.of<AppProvider>(context, listen: false).toggleFavorite(photo.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              _sharePhoto(photo);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Info'),
            onTap: () {
              Navigator.pop(context);
              _showPhotoInfo(photo);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              'Filter results',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Photos only'),
            onTap: () {
              Navigator.pop(context);
              _filterResults(PhotoType.image);
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Videos only'),
            onTap: () {
              Navigator.pop(context);
              _filterResults(PhotoType.video);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites only'),
            onTap: () {
              Navigator.pop(context);
              _filterFavorites();
            },
          ),
          ListTile(
            leading: const Icon(Icons.clear),
            title: const Text('Clear filters'),
            onTap: () {
              Navigator.pop(context);
              _performSearch(_currentQuery);
            },
          ),
        ],
      ),
    );
  }

  void _filterResults(PhotoType type) {
    setState(() {
      _searchResults = _searchResults.where((photo) => photo.type == type).toList();
    });
  }

  void _filterFavorites() {
    setState(() {
      _searchResults = _searchResults.where((photo) => photo.isFavorite).toList();
    });
  }

  void _sharePhoto(Photo photo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${photo.name}')),
    );
  }

  void _showPhotoInfo(Photo photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(photo.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${photo.dateCreated.toString().split('.')[0]}'),
            Text('Size: ${(photo.size / 1024 / 1024).toStringAsFixed(1)} MB'),
            Text('Dimensions: ${photo.width} × ${photo.height}'),
            if (photo.location != null) Text('Location: ${photo.location}'),
            if (photo.tags.isNotEmpty) Text('Tags: ${photo.tags.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addToRecentSearches(String query) {
    // TODO: Implement persistent recent searches storage
  }

  void _removeRecentSearch(String search) {
    // TODO: Implement removing from recent searches
  }

  void _clearRecentSearches() {
    // TODO: Implement clearing all recent searches
  }
}