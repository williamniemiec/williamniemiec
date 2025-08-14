import 'package:flutter/material.dart';

class UnifiedSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          'Search or type a command...',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}