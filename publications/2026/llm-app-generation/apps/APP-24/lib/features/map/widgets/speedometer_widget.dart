import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/services/location_service.dart';

class SpeedometerWidget extends StatefulWidget {
  const SpeedometerWidget({super.key});

  @override
  State<SpeedometerWidget> createState() => _SpeedometerWidgetState();
}

class _SpeedometerWidgetState extends State<SpeedometerWidget> {
  final LocationService _locationService = LocationService();
  double _currentSpeed = 0.0;
  double _speedLimit = 50.0; // Default speed limit in km/h

  @override
  void initState() {
    super.initState();
    _listenToLocationUpdates();
  }

  void _listenToLocationUpdates() {
    _locationService.locationStream.listen((location) {
      if (mounted && location.speed != null) {
        setState(() {
          _currentSpeed = location.speed! * 3.6; // Convert m/s to km/h
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverSpeedLimit = _currentSpeed > _speedLimit + AppConstants.speedLimitTolerance;
    
    return Container(
      width: AppConstants.speedometerSize,
      height: AppConstants.speedometerSize,
      decoration: BoxDecoration(
        color: isOverSpeedLimit 
            ? const Color(AppColors.errorColor)
            : Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.speedometerSize / 2),
          onTap: () {
            _showSpeedDetails(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_currentSpeed.round()}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isOverSpeedLimit 
                      ? Colors.white 
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'km/h',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isOverSpeedLimit 
                      ? Colors.white.withOpacity(0.8)
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSpeedDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Speed Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpeedInfo(
                        context,
                        'Current Speed',
                        '${_currentSpeed.round()} km/h',
                        _currentSpeed > _speedLimit + AppConstants.speedLimitTolerance
                            ? const Color(AppColors.errorColor)
                            : const Color(AppColors.successColor),
                      ),
                      _buildSpeedInfo(
                        context,
                        'Speed Limit',
                        '${_speedLimit.round()} km/h',
                        Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedInfo(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}