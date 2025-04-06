class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final int stockQuantity;
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.stockQuantity,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Product(
        id: 0,
        name: 'Unknown Product',
        description: '',
        price: 0.0,
        imageUrl: null,
        stockQuantity: 0,
        category: Category(id: 0, name: 'Unknown', description: ''),
      );
    }

    // Handle the category field which could be null or a Map
    Category productCategory;
    var categoryData = json['category'];

    if (categoryData == null) {
      productCategory = Category(id: 0, name: 'Unknown', description: '');
    } else if (categoryData is Map<String, dynamic>) {
      productCategory = Category.fromJson(categoryData);
    } else {
      // If it's neither null nor a Map, create a default category
      productCategory = Category(id: 0, name: 'Unknown', description: '');
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? '',
      // Handle price which could be a string, number, or null
      price: _parsePrice(json['price']),
      imageUrl: json['imageUrl'],
      stockQuantity: json['stockQuantity'] ?? 0,
      category: productCategory,
    );
  }

  // Factory to create a placeholder/empty product
  factory Product.placeholder() {
    return Product(
      id: -1,
      name: "",
      price: 0.0,
      description: "",
      imageUrl: null,
      stockQuantity: 0,
      category: Category(id: 0, name: 'Unknown', description: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stockQuantity': stockQuantity,
      'category': category.toJson(), // Use category's toJson method
    };
  }

  @override
  String toString() {
    return name;
  }

  static double _parsePrice(dynamic price) {
    if (price == null) {
      return 0.0;
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      return price.toDouble();
    } else {
      return 0.0;
    }
  }

  // Add copyWith method to allow creating a copy with modified properties
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? stockQuantity,
    Category? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl, // Allow null to be passed explicitly
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
    );
  }
}

// lib/models/category.dart
class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
