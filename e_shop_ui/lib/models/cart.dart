// lib/models/cart.dart
import 'package:e_shop_ui/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  
  CartItem({
    required this.product,
    required this.quantity,
  });
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
  
  double get total => product.price * quantity;
}

class Cart {
  final int id;
  final List<CartItem> items;
  
  Cart({
    required this.id,
    required this.items,
  });
  
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
  
  double get total => items.fold(0, (sum, item) => sum + item.total);
}