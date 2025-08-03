// lib/screens/tabs_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journal/dummy_data.dart';
import 'package:journal/recipe.dart';
import 'package:journal/screens/recipe_list_screen.dart';
import 'package:journal/screens/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = prefs.getString('recipes');

    if (recipesJson != null) {
      final List<dynamic> jsonList = jsonDecode(recipesJson);
      _recipes = jsonList.map((json) => Recipe.fromJson(json)).toList();
    } else {
      _recipes = List.from(initialDummyRecipes);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = jsonEncode(_recipes.map((e) => e.toJson()).toList());
    await prefs.setString('recipes', recipesJson);
  }

  void _addRecipe(Recipe newRecipe) {
    setState(() {
      _recipes.add(newRecipe);
    });
    _saveRecipes();
  }

  void _updateRecipe(Recipe updatedRecipe) {
    setState(() {
      final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
      if (index != -1) {
        _recipes[index].isFavorite = updatedRecipe.isFavorite;
      }
    });
    _saveRecipes();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> pages = [
      RecipeListScreen(
        recipes: _recipes,
        addRecipe: _addRecipe,
        updateRecipe: _updateRecipe,
      ),
      FavoritesScreen(recipes: _recipes, updateRecipe: _updateRecipe),
    ];

    return Scaffold(
      body: pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Recipes'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
