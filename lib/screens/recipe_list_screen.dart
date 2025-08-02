// lib/screens/recipe_list_screen.dart

import 'package:flutter/material.dart';
import 'package:journal/dummy_data.dart';
import 'package:journal/recipe.dart';
import 'package:journal/screens/recipe_detail_screen.dart'; 

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  void _selectRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return RecipeDetailScreen(recipe: recipe);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('My Recipes', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: dummyRecipes.length,
        itemBuilder: (ctx, index) {
          final recipe = dummyRecipes[index];
          return InkWell(
            onTap: () => _selectRecipe(context, recipe),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        recipe.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
