import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_provider.dart';
import '../../../shared/models/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedProvider>(
      builder: (context, savedProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved'),
            actions: [
              IconButton(
                onPressed: () => _showCreateListDialog(savedProvider),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: savedProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : savedProvider.savedLists.isEmpty
                  ? _buildEmptyState()
                  : _buildSavedLists(savedProvider),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: AppTheme.hintTextColor,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'No saved places yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Save places you want to remember or visit later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.hintTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSavedLists(SavedProvider savedProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      itemCount: savedProvider.savedLists.length,
      itemBuilder: (context, index) {
        final list = savedProvider.savedLists[index];
        return _buildListCard(list, savedProvider);
      },
    );
  }

  Widget _buildListCard(SavedPlacesList list, SavedProvider savedProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: InkWell(
        onTap: () => _showListDetails(list, savedProvider),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  _getListIcon(list.iconName),
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (list.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        list.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${list.places.length} places',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.hintTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (!list.isDefault)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'rename':
                        _showRenameDialog(list, savedProvider);
                        break;
                      case 'delete':
                        _showDeleteDialog(list, savedProvider);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'rename',
                      child: Text('Rename'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showListDetails(SavedPlacesList list, SavedProvider savedProvider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _SavedPlacesListScreen(
          list: list,
          savedProvider: savedProvider,
        ),
      ),
    );
  }

  void _showCreateListDialog(SavedProvider savedProvider) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create new list'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'List name',
                hintText: 'e.g., Weekend trips',
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppConstants.spacingM),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'What\'s this list for?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                savedProvider.createList(
                  nameController.text,
                  description: descriptionController.text.isNotEmpty 
                      ? descriptionController.text 
                      : null,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(SavedPlacesList list, SavedProvider savedProvider) {
    final controller = TextEditingController(text: list.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename list'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'List name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty && controller.text != list.name) {
                savedProvider.renameList(list.id, controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(SavedPlacesList list, SavedProvider savedProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete list'),
        content: Text('Are you sure you want to delete "${list.name}"? This will also remove all saved places in this list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              savedProvider.deleteList(list.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getListIcon(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'flag':
        return Icons.flag;
      case 'star':
        return Icons.star;
      default:
        return Icons.bookmark;
    }
  }
}

class _SavedPlacesListScreen extends StatelessWidget {
  final SavedPlacesList list;
  final SavedProvider savedProvider;

  const _SavedPlacesListScreen({
    required this.list,
    required this.savedProvider,
  });

  @override
  Widget build(BuildContext context) {
    final places = savedProvider.getPlacesFromList(list.name);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
      ),
      body: places.isEmpty
          ? _buildEmptyListState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final savedPlace = places[index];
                return _buildPlaceCard(context, savedPlace);
              },
            ),
    );
  }

  Widget _buildEmptyListState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: AppTheme.hintTextColor,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'No places in this list',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Save places from the map to see them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.hintTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, SavedPlace savedPlace) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    savedPlace.place.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (savedPlace.isFavorite)
                  const Icon(
                    Icons.favorite,
                    color: AppTheme.errorColor,
                    size: 16,
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'favorite':
                        savedProvider.toggleFavorite(savedPlace.id);
                        break;
                      case 'remove':
                        savedProvider.removePlace(savedPlace.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'favorite',
                      child: Text(savedPlace.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove from list'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingXS),
            Text(
              savedPlace.place.address,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
            if (savedPlace.notes != null) ...[
              const SizedBox(height: AppConstants.spacingS),
              Text(
                savedPlace.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.hintTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Saved ${_formatDate(savedPlace.savedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.hintTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}