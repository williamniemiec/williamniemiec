import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final String initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Search Screen\nComing Soon!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            if (initialQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Initial Query: $initialQuery'),
            ],
          ],
        ),
      ),
    );
  }
}