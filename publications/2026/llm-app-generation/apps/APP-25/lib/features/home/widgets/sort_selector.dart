import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class SortSelector extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortSelector({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip(context, AppConstants.sortHot, 'Hot', Icons.local_fire_department),
                  const SizedBox(width: AppConstants.smallPadding),
                  _buildSortChip(context, AppConstants.sortNew, 'New', Icons.fiber_new),
                  const SizedBox(width: AppConstants.smallPadding),
                  _buildSortChip(context, AppConstants.sortTop, 'Top', Icons.trending_up),
                  const SizedBox(width: AppConstants.smallPadding),
                  _buildSortChip(context, AppConstants.sortRising, 'Rising', Icons.trending_up),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(BuildContext context, String sortType, String label, IconData icon) {
    final isSelected = currentSort == sortType;
    
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onSortChanged(sortType),
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
      ),
    );
  }
}