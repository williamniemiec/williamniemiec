import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/trip.dart';

class RideOptionsList extends StatelessWidget {
  final List<RideOption> options;
  final RideOption? selectedOption;
  final Function(RideOption) onOptionSelected;

  const RideOptionsList({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppConstants.paddingS),
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedOption?.type == option.type;
        
        return _RideOptionCard(
          option: option,
          isSelected: isSelected,
          onTap: () => onOptionSelected(option),
        );
      },
    );
  }
}

class _RideOptionCard extends StatelessWidget {
  final RideOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _RideOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.isAvailable ? onTap : null,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // Vehicle Icon
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Icon(
                _getVehicleIcon(option.type),
                size: AppConstants.iconL,
                color: option.isAvailable ? Colors.black : Colors.grey,
              ),
            ),
            
            const SizedBox(width: AppConstants.paddingM),
            
            // Option Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: option.isAvailable ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      if (!option.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(AppConstants.radiusS),
                          ),
                          child: Text(
                            'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 2),
                  
                  Text(
                    option.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingS),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${option.estimatedTime} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingM),
                      Icon(
                        Icons.people,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${option.capacity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${option.estimatedFare.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: option.isAvailable ? Colors.black : Colors.grey,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: const Text(
                      'Selected',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVehicleIcon(RideType type) {
    switch (type) {
      case RideType.uberX:
        return Icons.directions_car;
      case RideType.comfort:
        return Icons.airline_seat_recline_extra;
      case RideType.uberXL:
        return Icons.airport_shuttle;
      case RideType.black:
        return Icons.local_taxi;
      case RideType.premier:
        return Icons.star;
      case RideType.green:
        return Icons.eco;
      case RideType.pet:
        return Icons.pets;
    }
  }
}