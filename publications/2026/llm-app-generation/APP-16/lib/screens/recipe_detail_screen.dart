import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_rover/bloc/recipe_bloc.dart';
import 'package:recipe_rover/bloc/recipe_event.dart';
import 'package:recipe_rover/widgets/recipe_card.dart';
import 'package:recipe_rover/bloc/recipe_state.dart';
import 'package:recipe_rover/utils/ingredient_check.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final List<String> userIngredients;

  const RecipeDetailScreen(
      {super.key, required this.recipeId, required this.userIngredients});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(GetRecipeDetails(widget.recipeId));
    context.read<RecipeBloc>().add(GetSimilarRecipes(widget.recipeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeDetailsLoaded) {
            final details = state.recipeDetails;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(details.imageUrl),
                  const SizedBox(height: 16.0),
                  Text(
                    details.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...checkIngredients(widget.userIngredients, details.ingredients)
                      .map((ingredientData) {
                    final ingredient = ingredientData['ingredient'];
                    final found = ingredientData['found'];
                    return Text(
                      '- ${ingredient.amount} ${ingredient.unit} ${ingredient.name}',
                      style: TextStyle(
                        backgroundColor: found ? Colors.transparent : Colors.yellow,
                      ),
                    );
                  }),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(details.instructions),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Similar Recipes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 200,
                    child: BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, similarState) {
                        if (similarState is SimilarRecipesLoaded) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarState.similarRecipes.length,
                            itemBuilder: (context, index) {
                              final similarRecipe =
                                  similarState.similarRecipes[index];
                              return SizedBox(
                                width: 150,
                                child: RecipeCard(recipe: similarRecipe),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  )
                ],
              ),
            );
          } else if (state is RecipeError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No details found.'));
        },
      ),
    );
  }
}