import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const LocationSearchBar({
    super.key,
    required this.controller,
    this.onClear,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
        decoration: InputDecoration(
          hintText: 'Search for a city or location...',
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.primaryBlue,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                  onPressed: onClear,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.primaryBlue,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}