import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/content.dart';

class ContentFilterBar extends StatelessWidget {
  final ContentCategory? selectedCategory;
  final DifficultyLevel? selectedDifficulty;
  final String? selectedPartner;
  final Function(ContentCategory?) onCategoryChanged;
  final Function(DifficultyLevel?) onDifficultyChanged;
  final Function(String?) onPartnerChanged;
  final VoidCallback onClearFilters;

  const ContentFilterBar({
    super.key,
    this.selectedCategory,
    this.selectedDifficulty,
    this.selectedPartner,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
    required this.onPartnerChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = selectedCategory != null ||
        selectedDifficulty != null ||
        selectedPartner != null;

    if (!hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (selectedCategory != null)
                _buildFilterChip(
                  label: selectedCategory!.name.toUpperCase(),
                  onDeleted: () => onCategoryChanged(null),
                ),
              if (selectedDifficulty != null)
                _buildFilterChip(
                  label: selectedDifficulty!.name.toUpperCase(),
                  onDeleted: () => onDifficultyChanged(null),
                ),
              if (selectedPartner != null)
                _buildFilterChip(
                  label: selectedPartner!,
                  onDeleted: () => onPartnerChanged(null),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      deleteIconColor: AppTheme.primaryColor,
      labelStyle: const TextStyle(color: AppTheme.primaryColor),
      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
    );
  }
}