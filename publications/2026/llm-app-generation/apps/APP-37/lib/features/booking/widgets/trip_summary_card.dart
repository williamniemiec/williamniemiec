import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/location.dart';

class TripSummaryCard extends StatelessWidget {
  final Location pickup;
  final Location destination;

  const TripSummaryCard({
    super.key,
    required this.pickup,
    required this.destination,
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
      child: Column(
        children: [
          _LocationRow(
            icon: Icons.radio_button_checked,
            iconColor: Colors.green,
            title: 'Pickup',
            address: pickup.address ?? pickup.name ?? 'Current location',
          ),
          
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
            child: Row(
              children: [
                const SizedBox(width: 32), // Align with icon
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          
          _LocationRow(
            icon: Icons.location_on,
            iconColor: Colors.red,
            title: 'Destination',
            address: destination.address ?? destination.name ?? 'Destination',
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String address;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: AppConstants.iconM,
        ),
        const SizedBox(width: AppConstants.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}