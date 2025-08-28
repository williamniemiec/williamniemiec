import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const SearchSuggestions({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'sunset',
      'beach',
      'family',
      'vacation',
      'food',
      'nature',
      'city',
      'friends',
      'pets',
      'flowers',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try searching for',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () => onSuggestionTap(suggestion),
              backgroundColor: Theme.of(context).colorScheme.surface,
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}