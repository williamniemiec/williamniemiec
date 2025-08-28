import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../saved/providers/saved_provider.dart';

class PlaceInfoSheet extends StatelessWidget {
  final Place place;
  final VoidCallback onClose;
  final Function(Place) onDirections;

  const PlaceInfoSheet({
    super.key,
    required this.place,
    required this.onClose,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedProvider>(
      builder: (context, savedProvider, child) {
        final isSaved = savedProvider.isPlaceSaved(place.id);
        
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppConstants.bottomSheetBorderRadius),
              topRight: Radius.circular(AppConstants.bottomSheetBorderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: AppConstants.spacingS),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.hintTextColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close),
                          color: AppTheme.secondaryTextColor,
                        ),
                      ],
                    ),
                    
                    // Rating and reviews
                    if (place.rating != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
                        child: Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < (place.rating ?? 0).floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                            const SizedBox(width: AppConstants.spacingXS),
                            Text(
                              '${place.rating}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (place.userRatingsTotal != null) ...[
                              const SizedBox(width: AppConstants.spacingXS),
                              Text(
                                '(${place.userRatingsTotal})',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.secondaryTextColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    
                    // Address
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppTheme.secondaryTextColor,
                            size: 16,
                          ),
                          const SizedBox(width: AppConstants.spacingXS),
                          Expanded(
                            child: Text(
                              place.address,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Opening hours
                    if (place.openingHours != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
                        child: Row(
                          children: [
                            Icon(
                              place.openingHours!.openNow ? Icons.access_time : Icons.access_time_filled,
                              color: place.openingHours!.openNow ? AppTheme.successColor : AppTheme.errorColor,
                              size: 16,
                            ),
                            const SizedBox(width: AppConstants.spacingXS),
                            Text(
                              place.openingHours!.openNow ? 'Open now' : 'Closed',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: place.openingHours!.openNow ? AppTheme.successColor : AppTheme.errorColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => onDirections(place),
                            icon: const Icon(Icons.directions),
                            label: const Text('Directions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        IconButton(
                          onPressed: () => _showSaveDialog(context, savedProvider),
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? AppTheme.primaryBlue : AppTheme.secondaryTextColor,
                          ),
                        ),
                        if (place.phoneNumber != null)
                          IconButton(
                            onPressed: () => _callPlace(place.phoneNumber!),
                            icon: const Icon(Icons.phone, color: AppTheme.secondaryTextColor),
                          ),
                        IconButton(
                          onPressed: () => _sharePlace(place),
                          icon: const Icon(Icons.share, color: AppTheme.secondaryTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSaveDialog(BuildContext context, SavedProvider savedProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Save to list',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.spacingM),
            ...savedProvider.savedLists.map((list) => ListTile(
              leading: Icon(_getListIcon(list.iconName)),
              title: Text(list.name),
              subtitle: Text('${list.places.length} places'),
              onTap: () {
                savedProvider.savePlace(place, list.name);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved to ${list.name}'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            )),
            const SizedBox(height: AppConstants.spacingS),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _showCreateListDialog(context, savedProvider);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create new list'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, SavedProvider savedProvider) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create new list'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'List name',
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
              if (controller.text.isNotEmpty) {
                savedProvider.createList(controller.text);
                savedProvider.savePlace(place, controller.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved to ${controller.text}'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: const Text('Create'),
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

  void _callPlace(String phoneNumber) {
    // In a real app, you would use url_launcher to make a phone call
    print('Calling: $phoneNumber');
  }

  void _sharePlace(Place place) {
    // In a real app, you would use the share package
    print('Sharing: ${place.name} - ${place.address}');
  }
}