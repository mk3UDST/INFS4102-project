import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/api/product_api.dart';
import 'package:e_shop_ui/models/cart.dart';
import 'package:e_shop_ui/models/cart_item.dart';
import 'package:e_shop_ui/models/product.dart';
import 'package:e_shop_ui/screens/order/order_screen.dart'; // Add this import

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Product>> _productsFuture;
  late Future<Cart> _cartFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _productsFuture = ProductApi.getAllProducts(); // Fetch all products
    _cartFuture = CartApi.getCartByUserId(1); // Fetch cart for userId 1
  }

  Future<void> _removeItem(CartItem item) async {
    setState(() => _isLoading = true);

    try {
      await CartApi.removeItemFromCart(1, item.product.id);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item removed from cart')));

      setState(() {
        _isLoading = false;
        _loadData();
      });
    } catch (e) {
      print('Error removing item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to remove item: ${e.toString().replaceAll('Exception:', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadData();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<dynamic>>(
              future: Future.wait([_productsFuture, _cartFuture]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error loading data: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Your cart is empty'));
                }

                final products = snapshot.data![0] as List<Product>;
                final cart = snapshot.data![1] as Cart;

                if (cart.items.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add some products to your cart',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Map cart items to products using productId or product.id
                final List<CartItem> enhancedCartItems = cart.items.map((cartItem) {
                  // Use productId if available, otherwise fall back to product.id
                  final int productIdToMatch = cartItem.productId ?? cartItem.product.id;
                  
                  final matchingProduct = products.firstWhere(
                    (product) => product.id == productIdToMatch,
                    orElse: () => Product(
                      id: productIdToMatch,
                      name: cartItem.product.name.isNotEmpty ? cartItem.product.name : 'Unknown',
                      price: cartItem.product.price > 0 ? cartItem.product.price : 0.0, description: '', stockQuantity: 1, category: cartItem.product.category,
                    ),
                  );

                  return CartItem(
                    id: cartItem.id,
                    product: matchingProduct,
                    quantity: cartItem.quantity,
                  );
                }).toList();

                // Calculate total
                double totalAmount = enhancedCartItems.fold(0, (sum, item) {
                  return sum + (item.product.price * item.quantity);
                });

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: enhancedCartItems.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          final item = enhancedCartItems[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Product Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: item.product.imageUrl != null
                                        ? Image.network(
                                            item.product.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.image_not_supported,
                                                size: 30,
                                                color: Colors.grey,
                                              );
                                            },
                                          )
                                        : const Icon(
                                            Icons.image,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Category: ${item.product.category.name}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${item.product.price.toStringAsFixed(2)} × ${item.quantity}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                            Text(
                                              '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Delete Button
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeItem(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Total price and checkout button
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total (${enhancedCartItems.length} ${enhancedCartItems.length == 1 ? 'item' : 'items'}):',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // Simplified navigation approach
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderScreen(
                                      cartItems: enhancedCartItems,
                                      totalAmount: totalAmount,
                                      cartId: cart.id,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _loadData();
                                  });
                                });
                              },
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
