import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_rover/models/recipe.dart';
import 'package:recipe_rover/models/recipe_details.dart';
import 'package:recipe_rover/utils/constants.dart';

class ApiService {
  Future<List<Recipe>> findRecipesByIngredients(String ingredients) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/recipes/findByIngredients?ingredients=$ingredients&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<RecipeDetails> getRecipeDetails(int recipeId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/recipes/$recipeId/information?apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RecipeDetails.fromMap(data);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  Future<List<Recipe>> getSimilarRecipes(int recipeId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/recipes/$recipeId/similar?apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load similar recipes');
    }
  }
}