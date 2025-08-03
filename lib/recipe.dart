// lib/recipe.dart

enum Complexity { simple, medium, complex }

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final int duration;
  final Complexity complexity;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.duration,
    required this.complexity,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
      'duration': duration,
      'complexity': complexity.index,
      'isFavorite': isFavorite,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      ingredients: (json['ingredients'] as List)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List)
          .map((e) => e as String)
          .toList(),
      duration: json['duration'] as int,
      complexity: Complexity.values[json['complexity'] as int],
      isFavorite: json['isFavorite'] as bool,
    );
  }
}
