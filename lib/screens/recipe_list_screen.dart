// lib/screens/recipe_list_screen.dart

import 'package:flutter/material.dart';
import 'package:journal/recipe.dart';
import 'package:journal/screens/recipe_detail_screen.dart';
import 'package:journal/screens/add_recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
  final List<Recipe> recipes;
  final Function(Recipe) addRecipe;
  final Function(Recipe) updateRecipe;

  const RecipeListScreen({
    super.key,
    required this.recipes,
    required this.addRecipe,
    required this.updateRecipe,
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
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

  void _addRecipe() async {
    final newRecipe = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(builder: (ctx) => const AddRecipeScreen()),
    );
    if (newRecipe != null) {
      widget.addRecipe(newRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = widget.recipes.where((recipe) {
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
                  hintText: 'Search recipes...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              )
            : const Text('My Recipes', style: TextStyle(color: Colors.white)),
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
                  icon: const Icon(
                    color: Colors.white,
                    Icons.search
                    ),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: filteredRecipes.isEmpty && !_searchQuery.isEmpty
          ? const Center(
              child: Text('No recipes found!', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (ctx, index) {
                final recipe = filteredRecipes[index];
                return InkWell(
                  onTap: () => _selectRecipe(context, recipe),
                  splashColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  recipe.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                if (recipe.isFavorite)
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
