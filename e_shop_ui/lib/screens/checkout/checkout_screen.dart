// lib/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/order_api.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/models/cart.dart'; 
import 'package:e_shop_ui/screens/orders/order_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  late Future<Cart> _cartFuture; // Added to prevent multiple API calls

  // Form fields
  String _address = '';
  String _city = '';
  String _zipCode = '';
  String _paymentMethod = 'Credit Card';

  @override
  void initState() {
    super.initState();
    // Load cart data once during initialization
    _cartFuture = CartApi.getCartByUserId(1);
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isProcessing = true);

      try {
        // Create shipping address from form fields
        String shippingAddress = '$_address, $_city, $_zipCode';
        
        // Hardcoded userId=1 for now
        final order = await OrderApi.createOrderFromCart(1, shippingAddress, _paymentMethod);

        // Navigate to order confirmation
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(orderId: order.id, order: order,),
          ),
          (route) => route.isFirst, // Keep only the first route (home)
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false); // Reset processing state on error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: _isProcessing 
        ? Center(
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
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Street Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) => _address = value ?? '',
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                          onSaved: (value) => _city = value ?? '',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Zip Code',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.pin),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter zip code';
                            }
                            return null;
                          },
                          onSaved: (value) => _zipCode = value ?? '',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    value: _paymentMethod,
                    items: [
                      DropdownMenuItem(
                        value: 'Credit Card',
                        child: Text('Credit Card'),
                      ),
                      DropdownMenuItem(
                        value: 'PayPal',
                        child: Text('PayPal'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _paymentMethod = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 32),
                  FutureBuilder<Cart>(
                    future: _cartFuture, // Use the pre-loaded cart future
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            children: [
                              Text('Error loading cart: ${snapshot.error}'),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _cartFuture = CartApi.getCartByUserId(1);
                                  });
                                },
                                child: Text('Retry'),
                              )
                            ],
                          )
                        );
                      } else if (!snapshot.hasData || snapshot.data?.items.isEmpty == true) {
                        return Center(
                          child: Column(
                            children: [
                              Text('Your cart is empty'),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Back to Shopping'),
                              )
                            ],
                          )
                        );
                      }

                      final cart = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
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
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${item.quantity}x ${item.product.name}',
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Text(
                                            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).toList(),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
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
                  SizedBox(height: 24),
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
                      child: Text(
                        'Place Order',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // Helper method to calculate cart total
  double _calculateCartTotal(Cart cart) {
    return cart.items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }
}
