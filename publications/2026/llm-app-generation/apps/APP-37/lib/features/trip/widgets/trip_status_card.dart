import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/trip.dart';

class TripStatusCard extends StatelessWidget {
  final Trip trip;

  const TripStatusCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                decoration: BoxDecoration(
                  color: _getStatusColor(trip.status),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Icon(
                  _getStatusIcon(trip.status),
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
                      trip.statusDisplayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (trip.estimatedDuration != null)
                      Text(
                        '${trip.estimatedDuration} min trip',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.requested:
        return Colors.orange;
      case TripStatus.accepted:
        return Colors.blue;
      case TripStatus.driverArriving:
        return Colors.purple;
      case TripStatus.inProgress:
        return Colors.green;
      case TripStatus.completed:
        return Colors.green;
      case TripStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(TripStatus status) {
    switch (status) {
      case TripStatus.requested:
        return Icons.search;
      case TripStatus.accepted:
        return Icons.check;
      case TripStatus.driverArriving:
        return Icons.directions_car;
      case TripStatus.inProgress:
        return Icons.navigation;
      case TripStatus.completed:
        return Icons.check_circle;
      case TripStatus.cancelled:
        return Icons.cancel;
    }
  }
}