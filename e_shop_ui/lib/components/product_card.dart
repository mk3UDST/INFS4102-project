// lib/components/product_card.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/models/product.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/screens/cart/cart_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({Key? key, required this.product, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FIXED: Create a constant Hero tag based on product ID
    final String heroTag = 'product-image-${product.id}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  // FIXED: Use the constant heroTag variable
                  child: Hero(
                    tag: heroTag,
                    child:
                        product.imageUrl?.isNotEmpty == true
                            ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                );
                              },
                            )
                            : Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.grey[400],
                                size: 40,
                              ),
                            ),
                  ),
                ),
              ),
            ),

            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category - FIXED: null safety
                    Text(
                      product.category as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),

                    // Product name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Price and add to cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        // Add to cart button
                        // FIXED: Use properly sized IconButton instead of Material+InkWell
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            onPressed: () {
                              // Add item to cart (userId=1 for now)
                              CartApi.addItemToCart(1, product.id, 1)
                                  .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.name} added to cart',
                                        ),
                                        duration: Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'View Cart',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CartScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  })
                                  .catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to add item to cart: ${error.toString()}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
