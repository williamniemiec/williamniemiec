import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class ServiceTabs extends StatelessWidget {
  final String selectedService;
  final Function(String) onServiceChanged;

  const ServiceTabs({
    super.key,
    required this.selectedService,
    required this.onServiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final services = [
      {'id': AppConstants.serviceStays, 'label': 'Stays', 'icon': Icons.hotel},
      {'id': AppConstants.serviceFlights, 'label': 'Flights', 'icon': Icons.flight},
      {'id': AppConstants.serviceCarRental, 'label': 'Car rental', 'icon': Icons.directions_car},
      {'id': AppConstants.serviceAttractions, 'label': 'Attractions', 'icon': Icons.local_activity},
      {'id': AppConstants.serviceTaxis, 'label': 'Taxis', 'icon': Icons.local_taxi},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: services.map((service) {
            final isSelected = selectedService == service['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onServiceChanged(service['id'] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: isSelected 
                        ? null 
                        : Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        service['icon'] as IconData,
                        size: 18,
                        color: isSelected ? AppTheme.primaryBlue : Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service['label'] as String,
                        style: TextStyle(
                          color: isSelected ? AppTheme.primaryBlue : Colors.white,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}