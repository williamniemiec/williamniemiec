import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ColoringToolbar extends StatelessWidget {
  final VoidCallback onHintPressed;
  final VoidCallback onResetZoom;
  final VoidCallback onShare;

  const ColoringToolbar({
    super.key,
    required this.onHintPressed,
    required this.onResetZoom,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hint Button
        _buildToolButton(
          context,
          icon: Icons.lightbulb_outline,
          tooltip: 'Show Hint',
          onPressed: onHintPressed,
        ),
        
        const SizedBox(width: AppConstants.paddingSmall),
        
        // Reset Zoom Button
        _buildToolButton(
          context,
          icon: Icons.zoom_out_map,
          tooltip: 'Reset Zoom',
          onPressed: onResetZoom,
        ),
        
        const SizedBox(width: AppConstants.paddingSmall),
        
        // Share Button
        _buildToolButton(
          context,
          icon: Icons.share,
          tooltip: 'Share',
          onPressed: onShare,
        ),
      ],
    );
  }

  Widget _buildToolButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              border: Border.all(
                color: AppConstants.textLight.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppConstants.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}