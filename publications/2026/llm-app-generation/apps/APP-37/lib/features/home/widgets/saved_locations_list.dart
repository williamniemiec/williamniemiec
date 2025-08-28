import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_provider.dart';

class SavedLocationsList extends ConsumerWidget {
  const SavedLocationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedLocations = ref.watch(savedLocationsProvider);

    if (savedLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Saved places',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          ...savedLocations.map((location) => _SavedLocationItem(
                location: location,
                onTap: () {
                  ref.read(destinationProvider.notifier).setDestination(location.location);
                },
              )),
        ],
      ),
    );
  }
}

class _SavedLocationItem extends StatelessWidget {
  final dynamic location; // SavedLocation
  final VoidCallback onTap;

  const _SavedLocationItem({
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingS),
              decoration: BoxDecoration(
                color: _getLocationColor(location.label),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Icon(
                _getLocationIcon(location.label),
                color: Colors.white,
                size: AppConstants.iconS,
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (location.location.address != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      location.location.address!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLocationIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  Color _getLocationColor(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Colors.blue;
      case 'work':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}