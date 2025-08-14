import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'cooking_mode_screen.dart';
import 'shopping_list_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late double _servings;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.recipe.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn('Prep Time', '${widget.recipe.prepTime} min'),
                      _buildInfoColumn('Cook Time', '${widget.recipe.cookTime} min'),
                      _buildInfoColumn('Servings', _servings.toInt().toString()),
                    ],
                  ),
                  Slider(
                    value: _servings,
                    min: 1,
                    max: 12,
                    divisions: 11,
                    label: _servings.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _servings = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.recipe.ingredients.map((ingredient) {
                    final scaledQuantity =
                        (ingredient.quantity / widget.recipe.servings) * _servings;
                    return Text(
                      '${scaledQuantity.toStringAsFixed(1)} ${ingredient.unit} ${ingredient.name}',
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShoppingListScreen(ingredients: widget.recipe.ingredients),
                        ),
                      );
                    },
                    child: const Text('Add to Shopping List'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CookingModeScreen(recipe: widget.recipe),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Start Cooking'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}