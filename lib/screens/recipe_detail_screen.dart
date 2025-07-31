

import 'package:flutter/material.dart';
import 'package:journal/recipe.dart'; // Import the Recipe model

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title), // Display the recipe title in the app bar
      ),
      body: Center(
        child: Text(
          'Details for ${recipe.title} will be displayed here!',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
