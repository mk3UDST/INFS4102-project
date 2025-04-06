import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          product.imageUrl != null && product.imageUrl!.isNotEmpty
              ? Image.network(
                product.imageUrl!,
                height: 100, // Reduced height
                width: 100, // Reduced width
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              )
              : Container(
                height: 100,
                width: 100,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Fixed line with null safety check
                Text(
                  product.category.name ?? 'Uncategorized',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  onPressed: () {
                    // Add to cart functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
