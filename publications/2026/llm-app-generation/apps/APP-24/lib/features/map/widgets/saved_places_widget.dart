import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class SavedPlacesWidget extends StatelessWidget {
  const SavedPlacesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPlaceButton(
          context,
          icon: Icons.home,
          label: AppStrings.home,
          onTap: () {
            // TODO: Navigate to home
          },
        ),
        const SizedBox(width: 12),
        _buildPlaceButton(
          context,
          icon: Icons.work,
          label: AppStrings.work,
          onTap: () {
            // TODO: Navigate to work
          },
        ),
      ],
    );
  }

  Widget _buildPlaceButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}