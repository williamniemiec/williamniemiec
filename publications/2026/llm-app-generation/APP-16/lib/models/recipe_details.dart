import 'package:recipe_rover/models/ingredient.dart';

class RecipeDetails {
  final int id;
  final String title;
  final String imageUrl;
  final int readyInMinutes;
  final int servings;
  final List<Ingredient> ingredients;
  final String instructions;

  RecipeDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.readyInMinutes,
    required this.servings,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeDetails.fromMap(Map<String, dynamic> map) {
    return RecipeDetails(
      id: map['id'],
      title: map['title'],
      imageUrl: map['image'],
      readyInMinutes: map['readyInMinutes'],
      servings: map['servings'],
      ingredients: (map['extendedIngredients'] as List)
          .map((ingredient) => Ingredient.fromMap(ingredient))
          .toList(),
      instructions: map['instructions'] ?? '',
    );
  }
}