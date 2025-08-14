import 'package:flutter/material.dart';
import 'package:recipe_rover/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            recipe.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}