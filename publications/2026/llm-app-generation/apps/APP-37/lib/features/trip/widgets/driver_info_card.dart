import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/trip.dart';

class DriverInfoCard extends StatelessWidget {
  final Driver driver;
  final Trip trip;

  const DriverInfoCard({
    super.key,
    required this.driver,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingM),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: driver.profileImageUrl != null
                ? NetworkImage(driver.profileImageUrl!)
                : null,
            child: driver.profileImageUrl == null
                ? Text(
                    driver.firstName[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      driver.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Text(
                      '${driver.totalTrips} trips',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${driver.vehicle.displayName} • ${driver.vehicle.licensePlate}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _callDriver(context),
                icon: const Icon(Icons.phone),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: AppConstants.paddingS),
              IconButton(
                onPressed: () => _messageDriver(context),
                icon: const Icon(Icons.message),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _callDriver(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling driver...')),
    );
  }

  void _messageDriver(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat...')),
    );
  }
}