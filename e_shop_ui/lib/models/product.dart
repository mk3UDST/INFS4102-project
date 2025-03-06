import 'package:e_shop_ui/models/category.dart';

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

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle category based on what the API returns
    Category productCategory;

    if (json['category'] == null) {
      productCategory = Category(id: 0, name: 'Unknown', description: '');
    } else if (json['category'] is Map<String, dynamic>) {
      productCategory = Category.fromJson(json['category']);
    } else if (json['category'] is int) {
      productCategory = Category(
        id: json['category'],
        name: 'Unknown',
        description: '',
      );
    } else {
      // Fallback with default category
      productCategory = Category(id: 0, name: 'Unknown', description: '');
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
      imageUrl: json['imageUrl'],
      stockQuantity: json['stockQuantity'] ?? 0,
      category: productCategory,
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
