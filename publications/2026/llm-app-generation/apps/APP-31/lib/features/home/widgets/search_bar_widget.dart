import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onSubmitted: onSearch,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search for products...',
          hintStyle: const TextStyle(
            color: AppTheme.textHint,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}