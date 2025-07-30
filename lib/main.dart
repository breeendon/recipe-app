import 'package:flutter/material.dart';

//jkjkjkjkjkjkjkjkjkjkjkjk

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('My Recipes', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text(
          'Recipes will appear here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
