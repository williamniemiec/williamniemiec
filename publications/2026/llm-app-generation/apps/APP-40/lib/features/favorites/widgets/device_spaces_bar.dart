import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants/app_constants.dart';

class DeviceSpacesBar extends StatefulWidget {
  const DeviceSpacesBar({super.key});

  @override
  State<DeviceSpacesBar> createState() => _DeviceSpacesBarState();
}

class _DeviceSpacesBarState extends State<DeviceSpacesBar> {
  String? selectedCategory;

  final List<SpaceCategory> categories = [
    SpaceCategory(
      id: 'cameras',
      name: 'Cameras',
      icon: MdiIcons.camera,
      count: 3,
    ),
    SpaceCategory(
      id: 'lighting',
      name: 'Lighting',
      icon: MdiIcons.lightbulb,
      count: 8,
    ),
    SpaceCategory(
      id: 'climate',
      name: 'Climate',
      icon: MdiIcons.thermostat,
      count: 2,
    ),
    SpaceCategory(
      id: 'security',
      name: 'Security',
      icon: MdiIcons.shield,
      count: 4,
    ),
    SpaceCategory(
      id: 'entertainment',
      name: 'Entertainment',
      icon: MdiIcons.speaker,
      count: 5,
    ),
    SpaceCategory(
      id: 'wifi',
      name: 'Wifi',
      icon: MdiIcons.wifi,
      count: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.id;

          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.smallPadding),
            child: _buildCategoryChip(category, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(SpaceCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? null : category.id;
        });
        _onCategorySelected(category);
      },
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (category.count > 0) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.count}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(SpaceCategory category) {
    // Handle category selection
    // This would typically filter devices by category
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${category.name} category'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class SpaceCategory {
  final String id;
  final String name;
  final IconData icon;
  final int count;

  const SpaceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
  });
}