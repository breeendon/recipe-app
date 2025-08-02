// lib/screens/recipe_list_screen.dart

import 'package:flutter/material.dart';
import 'package:journal/dummy_data.dart';
import 'package:journal/recipe.dart';
import 'package:journal/screens/recipe_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteRecipeIds') ?? [];

    setState(() {
      for (var recipe in dummyRecipes) {
        recipe.isFavorite = favoriteIds.contains(recipe.id);
      }
      _isLoading = false;
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = dummyRecipes
        .where((recipe) => recipe.isFavorite)
        .map((recipe) => recipe.id)
        .toList();
    await prefs.setStringList('favoriteRecipeIds', favoriteIds);
  }

  void _selectRecipe(BuildContext context, Recipe recipe) async {
    final updatedRecipe = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(
        builder: (ctx) {
          return RecipeDetailScreen(recipe: recipe);
        },
      ),
    );

    if (updatedRecipe != null) {
      setState(() {
        final index = dummyRecipes.indexWhere((r) => r.id == updatedRecipe.id);
        if (index != -1) {
          dummyRecipes[index].isFavorite = updatedRecipe.isFavorite;
        }
      });
      await _saveFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (recipe.isFavorite)
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
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
