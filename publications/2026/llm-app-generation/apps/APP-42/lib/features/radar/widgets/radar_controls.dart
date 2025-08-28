import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RadarControls extends StatelessWidget {
  final String selectedLayer;
  final VoidCallback onRefresh;
  final bool isLoading;

  const RadarControls({
    super.key,
    required this.selectedLayer,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
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
          // Layer info
          Expanded(
            child: Row(
              children: [
                Icon(
                  _getLayerIcon(selectedLayer),
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getLayerDisplayName(selectedLayer),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getLayerDescription(selectedLayer),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Refresh button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: isLoading ? null : onRefresh,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                      ),
                    )
                  : Icon(
                      Icons.refresh,
                      color: AppTheme.primaryBlue,
                    ),
              tooltip: 'Refresh radar data',
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLayerIcon(String layer) {
    switch (layer) {
      case 'precipitation':
        return Icons.grain;
      case 'satellite':
        return Icons.satellite_alt;
      case 'temperature':
        return Icons.thermostat;
      case 'wind':
        return Icons.air;
      default:
        return Icons.layers;
    }
  }

  String _getLayerDisplayName(String layer) {
    switch (layer) {
      case 'precipitation':
        return 'Precipitation';
      case 'satellite':
        return 'Satellite';
      case 'temperature':
        return 'Temperature';
      case 'wind':
        return 'Wind Speed';
      default:
        return 'Unknown Layer';
    }
  }

  String _getLayerDescription(String layer) {
    switch (layer) {
      case 'precipitation':
        return 'Rain, snow, and mixed precipitation';
      case 'satellite':
        return 'Cloud cover from space';
      case 'temperature':
        return 'Surface temperature data';
      case 'wind':
        return 'Wind speed and direction';
      default:
        return 'Weather data overlay';
    }
  }
}