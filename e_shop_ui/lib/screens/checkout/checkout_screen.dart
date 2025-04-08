// lib/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/order_api.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/models/cart.dart';
import 'package:e_shop_ui/screens/orders/order_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart? cart;

  const CheckoutScreen({super.key, this.cart});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;
  late Future<Cart> _cartFuture;

  @override
  void initState() {
    super.initState();
    // If cart was passed in, use it immediately, otherwise load from API
    if (widget.cart != null) {
      _cartFuture = Future.value(widget.cart!);
    } else {
      // Use the API as a fallback
      _cartFuture = _loadCartData();
    }
  }

  Future<Cart> _loadCartData() {
    // Hardcoded userId=1 for now
    return CartApi.getCartByUserId(1);
  }

  Future<void> _placeOrder() async {
    setState(() => _isProcessing = true);

    try {
      // Hardcoded userId=1 for now
      final order = await OrderApi.createOrderFromCart(1);

      print('Order created with ID: ${order.id}');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to order detail and then home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailScreen(orderId: order.id, order: order),
        ),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      // More detailed error logging
      print('Error placing order: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _placeOrder,
            textColor: Colors.white,
          ),
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing your order...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary Section
                  FutureBuilder<Cart>(
                    future: _cartFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            children: [
                              Text('Error loading cart: ${snapshot.error}'),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _cartFuture = _loadCartData();
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data?.items.isEmpty == true) {
                        return Center(
                          child: Column(
                            children: [
                              const Text('Your cart is empty'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Back to Shopping'),
                              ),
                            ],
                          ),
                        );
                      }

                      final cart = snapshot.data!;
                      final totalItems = cart.items.fold(0, (sum, item) => sum + item.quantity);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ...cart.items.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${item.quantity}× ${item.product.name}',
                                              style: const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Text(
                                            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Items',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$totalItems',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$${_calculateCartTotal(cart).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _placeOrder,
                      child: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper method to calculate cart total
  double _calculateCartTotal(Cart cart) {
    return cart.items.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }
}
