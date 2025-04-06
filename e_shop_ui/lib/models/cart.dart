import 'package:e_shop_ui/models/cart_item.dart';

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final double totalAmount;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartItem> cartItems = [];
    if (json['items'] != null) {
      cartItems =
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList();
    }

    return Cart(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 1, // Default to userId 1 if not provided
      items: cartItems,
      totalAmount:
          json['totalAmount'] is int
              ? (json['totalAmount'] as int).toDouble()
              : (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
    };
  }
}
