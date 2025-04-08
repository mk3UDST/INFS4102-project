import 'package:e_shop_ui/models/cart_item.dart';

class Cart {
  final int id;
  final List<CartItem> items;

  Cart({required this.id, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
    );
  }
}
