import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Todos',
      'Hambúrguer',
      'Pizza',
      'Japonesa',
      'Italiana',
      'Brasileira',
      'Mexicana',
      'Doces',
      'Saudável',
      'Bebidas',
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((category) {
            final isSelected = selectedCategory == category || 
                (selectedCategory.isEmpty && category == 'Todos');
            
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (category == 'Todos') {
                    onCategorySelected('');
                  } else {
                    onCategorySelected(selected ? category : '');
                  }
                },
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryRed.withOpacity(0.1),
                checkmarkColor: AppTheme.primaryRed,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryRed : AppTheme.textGrey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryRed : AppTheme.borderGrey,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}