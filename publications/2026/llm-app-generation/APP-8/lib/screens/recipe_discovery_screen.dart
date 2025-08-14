import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/recipe_card.dart';

class RecipeDiscoveryScreen extends StatelessWidget {
  const RecipeDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simmer'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.75,
        ),
        itemCount: dummyRecipes.length,
        itemBuilder: (context, index) {
          final recipe = dummyRecipes[index];
          return RecipeCard(recipe: recipe);
        },
      ),
    );
  }
}