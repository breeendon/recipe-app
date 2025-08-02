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
    this.isFavorite = false,
    required this.duration,
    required this.complexity,
  });
}
