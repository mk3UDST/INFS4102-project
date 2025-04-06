// lib/screens/products/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  void _addToCart() async {
    setState(() => _isAddingToCart = true);

    try {
      // Use the correct API endpoint to add items to the cart
      await CartApi.addItemToCart(1, widget.product.id, _quantity);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added to cart successfully!'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Wait for the snackbar to show briefly before navigating back
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add item to cart: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Product Details'), elevation: 0),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image - smaller, optimized height
                Container(
                  height: 220, // Reduced height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Hero(
                    tag:
                        'product-image-${widget.product.id}', // Match tag with card
                    child:
                        widget.product.imageUrl != null
                            ? Image.network(
                              widget.product.imageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                            : Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                  ),
                ),

                // Product details
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ), // Reduced vertical padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product header info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4), // Reduced spacing
                      // Category with icon
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.product.category.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8), // Reduced spacing
                      // Description
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.product.description.isEmpty
                                  ? 'No description available for this product.'
                                  : widget.product.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16), // Reduced spacing
                      // Quantity selector
                      Row(
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                // Decrease button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap:
                                        _quantity > 1
                                            ? () {
                                              setState(() => _quantity--);
                                            }
                                            : null,
                                    customBorder: const CircleBorder(),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.remove,
                                        size: 16,
                                        color:
                                            _quantity > 1
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),

                                // Quantity display with fixed width
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Increase button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap:
                                        _quantity < widget.product.stockQuantity
                                            ? () {
                                              setState(() => _quantity++);
                                            }
                                            : null,
                                    customBorder: const CircleBorder(),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color:
                                            _quantity <
                                                    widget.product.stockQuantity
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          Text(
                            'Available: ${widget.product.stockQuantity}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Extra space for the floating button
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Add to Cart button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              onPressed: _isAddingToCart ? null : _addToCart,
              child:
                  _isAddingToCart
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text(
                        'Add to Cart - \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
