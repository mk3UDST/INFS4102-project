import 'package:e_shop_ui/models/product.dart';

class OrderItem {
  final int id;
  final Product product;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}