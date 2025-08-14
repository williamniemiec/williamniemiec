import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_rover/api/api_service.dart';
import 'package:recipe_rover/bloc/recipe_event.dart';
import 'package:recipe_rover/bloc/recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final ApiService apiService;

  RecipeBloc(this.apiService) : super(RecipeInitial()) {
    on<SearchRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes =
            await apiService.findRecipesByIngredients(event.ingredients);
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(RecipeError(e.toString()));
      }
    });

    on<GetRecipeDetails>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipeDetails = await apiService.getRecipeDetails(event.recipeId);
        emit(RecipeDetailsLoaded(recipeDetails));
      } catch (e) {
        emit(RecipeError(e.toString()));
      }
    });

    on<GetSimilarRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final similarRecipes =
            await apiService.getSimilarRecipes(event.recipeId);
        emit(SimilarRecipesLoaded(similarRecipes));
      } catch (e) {
        emit(RecipeError(e.toString()));
      }
    });
  }
}