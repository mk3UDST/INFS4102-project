// lib/components/category_card.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/category.dart';
// Remove problematic import and use string-based navigation instead
// import 'package:e_shop_ui/screens/products/product_list_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Use named route navigation instead of direct class instantiation
          // This avoids the import issue with ProductListScreen
          Navigator.pushNamed(
            context,
            '/products',
            arguments: {
              'categoryId': category.id,
              'isNewCollection': false,
              'isFeatured': false,
            },
          );

          // Fallback if named routes aren't set up
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       // Create a simple placeholder screen until you fix the import
          //       return Scaffold(
          //         appBar: AppBar(title: Text(category.name)),
          //         body: Center(
          //           child: Text('Products in ${category.name} category'),
          //         ),
          //       );
          //     },
          //   ),
          // );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getCategoryIcon(category.name),
                color: Colors.white,
                size: 36,
              ),
              const Spacer(),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.checkroom;
      case 'books':
        return Icons.book;
      case 'shoes':
        return Icons.shopping_bag;
      case 'accessories':
        return Icons.watch;
      case 'home & kitchen':
        return Icons.home;
      case 'sports':
        return Icons.sports_soccer;
      case 'beauty':
        return Icons.face;
      default:
        return Icons.category;
    }
  }
}
