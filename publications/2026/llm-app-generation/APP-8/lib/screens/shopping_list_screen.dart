import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class ShoppingListScreen extends StatelessWidget {
  final List<Ingredient> ingredients;

  const ShoppingListScreen({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Ingredient>> groupedIngredients = {};
    for (var ingredient in ingredients) {
      if (groupedIngredients.containsKey(ingredient.category)) {
        groupedIngredients[ingredient.category]!.add(ingredient);
      } else {
        groupedIngredients[ingredient.category] = [ingredient];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView(
        children: groupedIngredients.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...entry.value.map((ingredient) {
                return ListTile(
                  title: Text(ingredient.name),
                  subtitle: Text('${ingredient.quantity} ${ingredient.unit}'),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}