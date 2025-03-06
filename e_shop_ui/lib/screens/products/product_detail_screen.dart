// lib/screens/products/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/cart_api.dart';
import 'package:e_shop_ui/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;
  
  void _addToCart() async {
    setState(() => _isAddingToCart = true);
    
    try {
      // Hardcoded userId=1 for now
      await CartApi.addItemToCart(1, widget.product.id, _quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully!'), duration: Duration(seconds: 2))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e'), duration: Duration(seconds: 2))
      );
    } finally {
      setState(() => _isAddingToCart = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Hero(
                tag: 'product-${widget.product.id}',
                child: widget.product.imageUrl != null 
                  ? Image.network(widget.product.imageUrl!, fit: BoxFit.contain)
                  : Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Category: ${widget.product.category.name}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                            ),
                            Text(
                              '$_quantity',
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _quantity < widget.product.stockQuantity
                                ? () => setState(() => _quantity++)
                                : null,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Available: ${widget.product.stockQuantity}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _isAddingToCart ? null : _addToCart,
                    child: _isAddingToCart
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add to Cart', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}