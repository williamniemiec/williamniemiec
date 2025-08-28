import 'package:flutter/material.dart';
import '../../../shared/models/weather_location.dart';

class LocationHeader extends StatelessWidget {
  final WeatherLocation? location;
  final bool isLoading;

  const LocationHeader({
    super.key,
    this.location,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Loading location...'),
        ],
      );
    }

    if (location == null) {
      return const Text('Unknown Location');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (location!.isCurrentLocation)
              const Icon(
                Icons.my_location,
                size: 16,
              ),
            if (location!.isCurrentLocation)
              const SizedBox(width: 4),
            Flexible(
              child: Text(
                location!.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (location!.region.isNotEmpty || location!.country.isNotEmpty)
          Text(
            [location!.region, location!.country]
                .where((s) => s.isNotEmpty)
                .join(', '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
      ],
    );
  }
}