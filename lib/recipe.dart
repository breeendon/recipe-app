
class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });
}
