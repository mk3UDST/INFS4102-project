import 'package:e_shop_ui/models/product.dart';

class CartItem {
  final int id;
  final Product product;
  final int quantity;

  CartItem({required this.id, required this.product, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'product': product.toJson(), 'quantity': quantity};
  }
}
