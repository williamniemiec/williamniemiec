import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/step.dart';

final List<Recipe> dummyRecipes = [
  Recipe(
    id: '1',
    title: 'Moqueca de Camarão',
    imageUrl: 'https://via.placeholder.com/600x400',
    prepTime: 20,
    cookTime: 30,
    servings: 2,
    ingredients: [
      Ingredient(name: 'Large shrimp', quantity: 500, unit: 'g', category: 'Seafood'),
      Ingredient(name: 'Coconut milk', quantity: 400, unit: 'ml', category: 'Pantry'),
      Ingredient(name: 'Dende oil', quantity: 2, unit: 'tbsp', category: 'Pantry'),
      Ingredient(name: 'Onion, chopped', quantity: 1, unit: 'medium', category: 'Produce'),
      Ingredient(name: 'Red bell pepper, chopped', quantity: 1, unit: 'large', category: 'Produce'),
      Ingredient(name: 'Garlic, minced', quantity: 3, unit: 'cloves', category: 'Produce'),
      Ingredient(name: 'Tomato paste', quantity: 2, unit: 'tbsp', category: 'Pantry'),
      Ingredient(name: 'Fresh cilantro, chopped', quantity: 0.5, unit: 'cup', category: 'Produce'),
      Ingredient(name: 'Lime juice', quantity: 1, unit: 'tbsp', category: 'Produce'),
    ],
    steps: [
      RecipeStep(instruction: 'Chop the onions and peppers.'),
      RecipeStep(instruction: 'Sauté the onions and peppers in a pan for 5 minutes.', timerInMinutes: 5),
      RecipeStep(instruction: 'Add garlic and cook for another minute.'),
      RecipeStep(instruction: 'Stir in tomato paste and cook for 2 minutes longer.'),
      RecipeStep(instruction: 'Add coconut milk and dende oil. Bring to a simmer.'),
      RecipeStep(instruction: 'Add shrimp and cook until pink, about 5-7 minutes.', timerInMinutes: 7),
      RecipeStep(instruction: 'Stir in cilantro and lime juice. Serve immediately.'),
    ],
  ),
];