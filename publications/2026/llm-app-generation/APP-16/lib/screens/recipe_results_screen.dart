import 'package:flutter/material.dart';
import 'package:recipe_rover/models/recipe.dart';
import 'package:recipe_rover/screens/recipe_detail_screen.dart';
import 'package:recipe_rover/widgets/recipe_card.dart';

class RecipeResultsScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final List<String> userIngredients;

  const RecipeResultsScreen(
      {super.key, required this.recipes, required this.userIngredients});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Results'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(
                    recipeId: recipe.id,
                    userIngredients: userIngredients,
                  ),
                ),
              );
            },
            child: RecipeCard(recipe: recipe),
          );
        },
      ),
    );
  }
}