import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70, // Reduced width
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4), // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum size
            children: [
              // Category icon
              Icon(
                _getCategoryIcon(category.name),
                color: Theme.of(context).primaryColor,
                size: 24, // Smaller icon
              ),
              SizedBox(height: 4), // Reduced spacing
              // Category name - with limited height
              Flexible(
                // Allow text to be sized appropriately
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10), // Smaller text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to get an appropriate icon for category
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.shopping_bag;
      case 'books':
        return Icons.book;
      case 'furniture':
        return Icons.chair;
      case 'sports':
        return Icons.sports_basketball;
      case 'toys':
        return Icons.toys;
      case 'grocery':
        return Icons.local_grocery_store;
      case 'beauty':
        return Icons.face;
      default:
        return Icons.category;
    }
  }
}
