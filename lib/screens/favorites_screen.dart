// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:journal/recipe.dart';
import 'package:journal/screens/recipe_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> recipes;
  final Function(Recipe) updateRecipe;

  const FavoritesScreen({
    super.key,
    required this.recipes,
    required this.updateRecipe,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      widget.updateRecipe(updatedRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = widget.recipes
        .where((recipe) => recipe.isFavorite)
        .toList();

    if (favoriteRecipes.isEmpty && _searchQuery.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'My Favorites',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text(
            'No favorite recipes yet!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final filteredFavoriteRecipes = favoriteRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search favorites...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              )
            : const Text('My Favorites', style: TextStyle(color: Colors.white)),
        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: filteredFavoriteRecipes.isEmpty && !_searchQuery.isEmpty
          ? const Center(
              child: Text('No recipes found!', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: filteredFavoriteRecipes.length,
              itemBuilder: (ctx, index) {
                final recipe = filteredFavoriteRecipes[index];
                return InkWell(
                  onTap: () => _selectRecipe(context, recipe),
                  splashColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: recipe.imageUrl.isNotEmpty
                              ? Image.network(
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
                                )
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text(
                                      'No Image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10,
                            ),
                            child: Text(
                              recipe.title,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
