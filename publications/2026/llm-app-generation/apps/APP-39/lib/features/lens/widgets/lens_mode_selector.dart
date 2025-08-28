import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class LensModeSelector extends StatelessWidget {
  final String selectedMode;
  final Function(String) onModeChanged;

  const LensModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.lensModes.length,
        itemBuilder: (context, index) {
          final mode = AppConstants.lensModes[index];
          final isSelected = mode == selectedMode;
          
          return GestureDetector(
            onTap: () => onModeChanged(mode),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.3),
                      border: isSelected
                          ? Border.all(color: AppTheme.primaryBlue, width: 2)
                          : null,
                    ),
                    child: Icon(
                      _getModeIcon(mode),
                      color: isSelected ? AppTheme.primaryBlue : Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mode,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'Search':
        return Icons.search;
      case 'Translate':
        return Icons.translate;
      case 'Text':
        return Icons.text_fields;
      case 'Homework':
        return Icons.school;
      case 'Shopping':
        return Icons.shopping_bag;
      default:
        return Icons.search;
    }
  }
}