import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/weather_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';

class SavedLocationsList extends StatelessWidget {
  final Function(Location) onLocationSelected;

  const SavedLocationsList({
    super.key,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final savedLocations = weatherProvider.savedLocations;

        if (savedLocations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No saved locations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Search for locations to save them for quick access',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: savedLocations.length,
          itemBuilder: (context, index) {
            final savedLocation = savedLocations[index];
            final location = savedLocation.location;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: savedLocation.isDefault 
                        ? AppTheme.primaryBlue 
                        : AppTheme.lightBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    savedLocation.isDefault ? Icons.home : Icons.location_on,
                    color: savedLocation.isDefault 
                        ? Colors.white 
                        : AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                title: Text(
                  location.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.displayName),
                    if (savedLocation.isDefault)
                      Text(
                        'Default Location',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(
                    context,
                    value,
                    savedLocation,
                    weatherProvider,
                  ),
                  itemBuilder: (context) => [
                    if (!savedLocation.isDefault)
                      const PopupMenuItem(
                        value: 'set_default',
                        child: Row(
                          children: [
                            Icon(Icons.home, size: 20),
                            SizedBox(width: 8),
                            Text('Set as Default'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Remove', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => onLocationSelected(location),
              ),
            );
          },
        );
      },
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    SavedLocation savedLocation,
    WeatherProvider weatherProvider,
  ) async {
    try {
      switch (action) {
        case 'set_default':
          await weatherProvider.setDefaultLocation(savedLocation.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${savedLocation.location.name} set as default location'),
                backgroundColor: AppTheme.successGreen,
              ),
            );
          }
          break;
        case 'remove':
          final confirmed = await _showRemoveConfirmation(context, savedLocation);
          if (confirmed == true) {
            await weatherProvider.removeSavedLocation(savedLocation.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${savedLocation.location.name} removed'),
                  backgroundColor: AppTheme.warningRed,
                ),
              );
            }
          }
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.warningRed,
          ),
        );
      }
    }
  }

  Future<bool?> _showRemoveConfirmation(
    BuildContext context,
    SavedLocation savedLocation,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Location'),
        content: Text(
          'Are you sure you want to remove "${savedLocation.location.name}" from your saved locations?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.warningRed,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}