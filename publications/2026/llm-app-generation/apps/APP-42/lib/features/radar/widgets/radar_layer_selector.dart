import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RadarLayerSelector extends StatelessWidget {
  final String selectedLayer;
  final Map<String, String> layerOptions;
  final ValueChanged<String> onLayerChanged;

  const RadarLayerSelector({
    super.key,
    required this.selectedLayer,
    required this.layerOptions,
    required this.onLayerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.layers,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Layers',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...layerOptions.entries.map((entry) {
            final isSelected = entry.key == selectedLayer;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onLayerChanged(entry.key),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : null,
                    borderRadius: entry.key == layerOptions.keys.last
                        ? const BorderRadius.vertical(bottom: Radius.circular(12))
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getLayerIcon(entry.key),
                        size: 18,
                        color: isSelected ? AppTheme.primaryBlue : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppTheme.primaryBlue : null,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.check,
                          size: 16,
                          color: AppTheme.primaryBlue,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
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
}