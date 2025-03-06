// lib/screens/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/models/cart.dart';
import 'package:e_shop_ui/screens/checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart> _cartFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    // Hardcoded userId=1 for now
    _cartFuture = CartApi.getCartByUserId(1);
  }

  Future<void> _updateQuantity(int productId, int quantity) async {
    setState(() => _isLoading = true);
    try {
      await CartApi.updateCartItemQuantity(1, productId, quantity);
      _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeItem(int productId) async {
    setState(() => _isLoading = true);
    try {
      await CartApi.removeItemFromCart(1, productId);
      _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to remove: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearCart() async {
    setState(() => _isLoading = true);
    try {
      await CartApi.clearCart(1);
      _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to clear cart: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _clearCart,
            tooltip: 'Clear cart',
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : FutureBuilder<Cart>(
                future: _cartFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text('Continue Shopping'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }

                  Cart cart = snapshot.data!;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return Dismissible(
                              key: Key(item.product.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) => _removeItem(item.product.id),
                              child: Card(
                                margin: EdgeInsets.all(8),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child:
                                            item.product.imageUrl != null
                                                ? Image.network(
                                                  item.product.imageUrl!,
                                                )
                                                : Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.product.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '\$${item.product.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                size: 16,
                                              ),
                                              onPressed:
                                                  item.quantity > 1
                                                      ? () => _updateQuantity(
                                                        item.product.id,
                                                        item.quantity - 1,
                                                      )
                                                      : null,
                                            ),
                                            Text('${item.quantity}'),
                                            IconButton(
                                              icon: Icon(Icons.add, size: 16),
                                              onPressed:
                                                  () => _updateQuantity(
                                                    item.product.id,
                                                    item.quantity + 1,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Calculate cart total from items directly
                                Text(
                                  '\$${_calculateCartTotal(cart).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Checkout',
                                style: TextStyle(fontSize: 18),
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

  // Add a helper method to calculate cart total
  double _calculateCartTotal(Cart cart) {
    if (cart.items.isEmpty) {
      return 0.0;
    }

    return cart.items.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }
}
