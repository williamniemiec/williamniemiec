import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/document_provider.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/document.dart';
import '../../documents/widgets/document_list_item.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DocumentProvider>().searchDocuments(widget.initialQuery);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.toolbarColor,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search in Docs',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.hintTextColor),
          ),
          style: const TextStyle(fontSize: 18),
          onChanged: (query) {
            context.read<DocumentProvider>().searchDocuments(query);
          },
          onSubmitted: (query) {
            context.read<DocumentProvider>().searchDocuments(query);
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<DocumentProvider>().clearSearch();
                _focusNode.requestFocus();
              },
            ),
        ],
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, provider, child) {
          if (provider.searchQuery.isEmpty) {
            return _buildEmptySearchState();
          }

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.searchResults.isEmpty) {
            return _buildNoResultsState(provider.searchQuery);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search results header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${provider.searchResults.length} result${provider.searchResults.length == 1 ? '' : 's'} for "${provider.searchQuery}"',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ),

              // Search results list
              Expanded(
                child: ListView.builder(
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    final document = provider.searchResults[index];
                    return DocumentListItem(
                      document: document,
                      onTap: () => _openDocument(document),
                      onMorePressed: () => _showDocumentOptions(document),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.search,
            size: 64,
            color: AppTheme.hintTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Search your documents',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find documents by title or content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.hintTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Search suggestions
          _buildSearchSuggestions(),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(String query) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.hintTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.hintTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              context.read<DocumentProvider>().clearSearch();
              _focusNode.requestFocus();
            },
            child: const Text('Clear search'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = [
      'Recent documents',
      'Shared documents',
      'Templates',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick access',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...suggestions.map((suggestion) => ListTile(
          leading: Icon(
            _getSuggestionIcon(suggestion),
            color: AppTheme.primaryColor,
          ),
          title: Text(suggestion),
          onTap: () => _handleSuggestionTap(suggestion),
          contentPadding: EdgeInsets.zero,
        )),
      ],
    );
  }

  IconData _getSuggestionIcon(String suggestion) {
    switch (suggestion) {
      case 'Recent documents':
        return Icons.history;
      case 'Shared documents':
        return Icons.people;
      case 'Templates':
        return Icons.description_outlined;
      default:
        return Icons.folder;
    }
  }

  void _handleSuggestionTap(String suggestion) {
    switch (suggestion) {
      case 'Recent documents':
        Navigator.pop(context);
        break;
      case 'Shared documents':
        _searchController.text = 'shared:true';
        context.read<DocumentProvider>().searchDocuments('shared:true');
        break;
      case 'Templates':
        Navigator.pop(context);
        AppRouter.goToTemplates(context);
        break;
    }
  }

  void _openDocument(Document document) {
    AppRouter.goToEditor(context, documentId: document.id);
  }

  void _showDocumentOptions(Document document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Open'),
            onTap: () {
              Navigator.pop(context);
              _openDocument(document);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement sharing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing feature coming soon')),
              );
            },
          ),
          ListTile(
            leading: Icon(
              document.isOfflineAvailable 
                ? Icons.cloud_done 
                : Icons.offline_pin,
            ),
            title: Text(
              document.isOfflineAvailable 
                ? 'Remove from offline' 
                : 'Make available offline',
            ),
            onTap: () {
              Navigator.pop(context);
              _toggleOfflineAvailability(document);
            },
          ),
        ],
      ),
    );
  }

  void _toggleOfflineAvailability(Document document) {
    final provider = context.read<DocumentProvider>();
    if (document.isOfflineAvailable) {
      provider.removeDocumentFromOffline(document.id);
    } else {
      provider.makeDocumentOfflineAvailable(document.id);
    }
  }
}