import 'package:recipe_rover/models/recipe.dart';
import 'package:recipe_rover/models/recipe_details.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoaded(this.recipes);
}

class RecipeDetailsLoaded extends RecipeState {
  final RecipeDetails recipeDetails;

  RecipeDetailsLoaded(this.recipeDetails);
}

class SimilarRecipesLoaded extends RecipeState {
  final List<Recipe> similarRecipes;

  SimilarRecipesLoaded(this.similarRecipes);
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);
}