import 'package:flutter/foundation.dart';
import 'ingredient.dart';
import 'step.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final int cookTime;
  final int prepTime;
  final int servings;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.cookTime,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
  });
}