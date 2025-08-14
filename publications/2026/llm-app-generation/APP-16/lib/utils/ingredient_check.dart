import 'package:recipe_rover/models/ingredient.dart';

List<Map<String, dynamic>> checkIngredients(
    List<String> userIngredients, List<Ingredient> recipeIngredients) {
  final List<Map<String, dynamic>> result = [];

  for (final recipeIngredient in recipeIngredients) {
    bool found = false;
    for (final userIngredient in userIngredients) {
      if (recipeIngredient.name.toLowerCase().contains(userIngredient.toLowerCase())) {
        found = true;
        break;
      }
    }
    result.add({
      'ingredient': recipeIngredient,
      'found': found,
    });
  }

  return result;
}