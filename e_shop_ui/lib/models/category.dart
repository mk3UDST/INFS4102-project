// lib/models/category.dart
class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Category(id: 0, name: 'Unknown', description: '');
    }

    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  @override
  String toString() {
    return name;
  }
}
