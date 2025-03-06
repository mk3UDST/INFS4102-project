import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  
  const CategoryCard({
    Key? key, 
    required this.category, 
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category icon based on name
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(category.name),
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
            SizedBox(height: 8),
            // Category name
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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