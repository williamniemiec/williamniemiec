import 'package:flutter/material.dart';

enum FeedFilter {
  all,
  district,
  school,
  classroom,
  urgent,
}

extension FeedFilterExtension on FeedFilter {
  String get label {
    switch (this) {
      case FeedFilter.all:
        return 'All';
      case FeedFilter.district:
        return 'District';
      case FeedFilter.school:
        return 'School';
      case FeedFilter.classroom:
        return 'Classroom';
      case FeedFilter.urgent:
        return 'Urgent';
    }
  }

  IconData get icon {
    switch (this) {
      case FeedFilter.all:
        return Icons.all_inclusive;
      case FeedFilter.district:
        return Icons.account_balance;
      case FeedFilter.school:
        return Icons.school;
      case FeedFilter.classroom:
        return Icons.class_;
      case FeedFilter.urgent:
        return Icons.priority_high;
    }
  }
}

class FeedFilterWidget extends StatelessWidget {
  final FeedFilter currentFilter;
  final ValueChanged<FeedFilter> onFilterChanged;

  const FeedFilterWidget({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FeedFilter.values.length,
        itemBuilder: (context, index) {
          final filter = FeedFilter.values[index];
          final isSelected = filter == currentFilter;
          
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == FeedFilter.values.length - 1 ? 0 : 0,
            ),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 16,
                    color: isSelected 
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 4),
                  Text(filter.label),
                ],
              ),
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              labelStyle: TextStyle(
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}