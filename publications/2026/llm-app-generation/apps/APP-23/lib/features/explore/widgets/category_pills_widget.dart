import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class CategoryPillsWidget extends StatelessWidget {
  final Function(String) onCategoryTap;

  const CategoryPillsWidget({
    super.key,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXS),
        itemCount: AppConstants.searchCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppConstants.spacingS),
        itemBuilder: (context, index) {
          final category = AppConstants.searchCategories[index];
          return _buildCategoryPill(
            context,
            category['name']!,
            category['icon']!,
            category['type']!,
          );
        },
      ),
    );
  }

  Widget _buildCategoryPill(
    BuildContext context,
    String name,
    String icon,
    String type,
  ) {
    return GestureDetector(
      onTap: () => onCategoryTap(type),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: AppConstants.spacingXS),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}