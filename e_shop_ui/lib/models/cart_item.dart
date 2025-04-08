import 'package:e_shop_ui/models/product.dart';

class CartItem {
  final int id;
  final int productId;
  final int quantity;

  CartItem({required this.id, required this.productId, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'productId': productId, 'quantity': quantity};
  }
}
