class WeightOption {
  final String label;
  final double priceModifier;

  WeightOption({required this.label, required this.priceModifier});

  factory WeightOption.fromJson(Map<String, dynamic> json) => WeightOption(
        label: json['label'] ?? '',
        priceModifier: (json['priceModifier'] ?? 0).toDouble(),
      );
}

class Product {
  final String id;
  final String name;
  final String slug;
  final String categoryId;
  final List<String> images;
  final double price;
  final double discountPercent;
  final String description;
  final List<String> ingredients;
  final List<WeightOption> weightOptions;
  final bool isAvailable;
  final double ratingAverage;
  final int ratingCount;
  final List<String> tags;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.categoryId,
    required this.images,
    required this.price,
    required this.discountPercent,
    required this.description,
    required this.ingredients,
    required this.weightOptions,
    required this.isAvailable,
    required this.ratingAverage,
    required this.ratingCount,
    required this.tags,
  });

  double get finalPrice => double.parse((price * (1 - discountPercent / 100)).toStringAsFixed(2));

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        categoryId: json['category'] is Map ? json['category']['_id'] : (json['category'] ?? ''),
        images: List<String>.from(json['images'] ?? []),
        price: (json['price'] ?? 0).toDouble(),
        discountPercent: (json['discountPercent'] ?? 0).toDouble(),
        description: json['description'] ?? '',
        ingredients: List<String>.from(json['ingredients'] ?? []),
        weightOptions: (json['weightOptions'] as List? ?? []).map((w) => WeightOption.fromJson(w)).toList(),
        isAvailable: json['isAvailable'] ?? true,
        ratingAverage: (json['ratingAverage'] ?? 0).toDouble(),
        ratingCount: json['ratingCount'] ?? 0,
        tags: List<String>.from(json['tags'] ?? []),
      );
}
