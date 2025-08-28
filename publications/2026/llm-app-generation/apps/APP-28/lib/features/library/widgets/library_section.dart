import 'package:flutter/material.dart';

class LibrarySection extends StatelessWidget {
  final String title;
  final Widget? action;
  final List<Widget> children;

  const LibrarySection({
    super.key,
    required this.title,
    this.action,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (action != null) action!,
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}