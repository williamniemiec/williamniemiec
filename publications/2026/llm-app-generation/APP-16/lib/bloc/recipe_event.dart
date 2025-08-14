abstract class RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String ingredients;

  SearchRecipes(this.ingredients);
}

class GetRecipeDetails extends RecipeEvent {
  final int recipeId;

  GetRecipeDetails(this.recipeId);
}

class GetSimilarRecipes extends RecipeEvent {
  final int recipeId;

  GetSimilarRecipes(this.recipeId);
}