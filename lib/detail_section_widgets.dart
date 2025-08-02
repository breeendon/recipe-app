import 'package:flutter/material.dart';

class IngredientsList extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return _buildContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredients.map((ingredient) {
          return Text('- $ingredient', style: const TextStyle(fontSize: 16));
        }).toList(),
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}

class InstructionsList extends StatelessWidget {
  final List<String> instructions;

  const InstructionsList({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return _buildContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: instructions.map((instruction) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(instruction, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}
