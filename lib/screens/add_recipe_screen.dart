// lib/screens/add_recipe_screen.dart

import 'package:flutter/material.dart';
import 'package:journal/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _durationController = TextEditingController();

  Complexity _selectedComplexity = Complexity.simple;

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newRecipe = Recipe(
        id: DateTime.now().toString(), // Simple unique ID
        title: _titleController.text,
        imageUrl: _imageUrlController.text,
        ingredients: _ingredientsController.text
            .split('\n')
            .map((e) => e.trim())
            .toList(),
        instructions: _instructionsController.text
            .split('\n')
            .map((e) => e.trim())
            .toList(),
        duration: int.parse(_durationController.text),
        complexity: _selectedComplexity,
        isFavorite: false,
      );

      Navigator.of(context).pop(newRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                    labelText: 'Ingredients (one per line)',
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one ingredient.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Instructions (one per line)',
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one instruction.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (in minutes)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid duration.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Complexity>(
                  decoration: const InputDecoration(labelText: 'Complexity'),
                  value: _selectedComplexity,
                  items: Complexity.values.map((complexity) {
                    return DropdownMenuItem(
                      value: complexity,
                      child: Text(complexity.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (Complexity? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedComplexity = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
