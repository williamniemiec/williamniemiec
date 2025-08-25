import 'package:flutter/material.dart';
import '../models/coloring_page.dart' as models;
import '../constants/app_constants.dart';

class ColorPaletteWidget extends StatelessWidget {
  final List<models.ColorPalette> availableColors;
  final List<models.ColorPalette> completedColors;
  final int? selectedColorNumber;
  final Function(int) onColorSelected;

  const ColorPaletteWidget({
    super.key,
    required this.availableColors,
    required this.completedColors,
    required this.selectedColorNumber,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allColors = [...availableColors, ...completedColors];
    allColors.sort((a, b) => a.number.compareTo(b.number));

    return Container(
      height: 120,
      color: AppConstants.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Text(
                  'Color Palette',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${completedColors.length}/${allColors.length} colors used',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Color List
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              itemCount: allColors.length,
              itemBuilder: (context, index) {
                final colorPalette = allColors[index];
                final isCompleted = completedColors.any((c) => c.number == colorPalette.number);
                final isSelected = selectedColorNumber == colorPalette.number;
                final isAvailable = availableColors.any((c) => c.number == colorPalette.number);

                return Container(
                  margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
                  child: _buildColorItem(
                    context,
                    colorPalette,
                    isCompleted: isCompleted,
                    isSelected: isSelected,
                    isAvailable: isAvailable,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(
    BuildContext context,
    models.ColorPalette colorPalette, {
    required bool isCompleted,
    required bool isSelected,
    required bool isAvailable,
  }) {
    final color = Color(int.parse(colorPalette.colorCode.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: isAvailable ? () => onColorSelected(colorPalette.number) : null,
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          border: Border.all(
            color: isSelected 
                ? AppConstants.primaryColor 
                : AppConstants.textLight.withOpacity(0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Color Circle
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Color number
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          colorPalette.number.toString(),
                          style: TextStyle(
                            color: AppConstants.textPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Completion check mark
                    if (isCompleted)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 8,
                          ),
                        ),
                      ),

                    // Unavailable overlay
                    if (!isAvailable && !isCompleted)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Color name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Text(
                colorPalette.colorName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                  color: isAvailable || isCompleted 
                      ? AppConstants.textSecondary 
                      : AppConstants.textLight,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}