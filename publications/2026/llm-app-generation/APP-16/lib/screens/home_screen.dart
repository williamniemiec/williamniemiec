import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_rover/bloc/recipe_bloc.dart';
import 'package:recipe_rover/bloc/recipe_event.dart';
import 'package:recipe_rover/bloc/recipe_state.dart';
import 'package:recipe_rover/screens/recipe_results_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController ingredientsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Rover'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Enter ingredients (e.g., chicken, rice, tomatoes)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            BlocConsumer<RecipeBloc, RecipeState>(
              listener: (context, state) {
                if (state is RecipeLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeResultsScreen(
                        recipes: state.recipes,
                        userIngredients: ingredientsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                      ),
                    ),
                  );
                } else if (state is RecipeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    final ingredients = ingredientsController.text;
                    if (ingredients.isNotEmpty) {
                      context
                          .read<RecipeBloc>()
                          .add(SearchRecipes(ingredients));
                    }
                  },
                  child: const Text('Find Recipes'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}