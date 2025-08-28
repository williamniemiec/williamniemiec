import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  final String? selectedCategory;

  const ShopScreen({
    super.key,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory ?? 'Shop'),
      ),
      body: const Center(
        child: Text(
          'Shop Screen\nComing Soon!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}