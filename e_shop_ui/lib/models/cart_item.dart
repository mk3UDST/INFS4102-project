import 'package:e_shop_ui/models/product.dart';

class CartItem {
  final int id;
  final Product product;
  final int quantity;
  final int? _productId; // Private field to store productId

  CartItem({
    required this.id, 
    required this.product, 
    required this.quantity,
    int? productId,
  }) : _productId = productId;

  // Getter for productId that falls back to product.id if _productId is null
  int get productId => _productId ?? product.id;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    print('CartItem.fromJson: ${json.toString()}'); // Debug: Print the entire JSON

    // Extract productId from JSON
    final int? jsonProductId = json['productId'] != null ? 
        int.tryParse(json['productId'].toString()) : null;
    
    print('Extracted productId: $jsonProductId'); // Debug: Print extracted productId
    
    return CartItem(
      id: json['id'] ?? 0,
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 0,
      productId: jsonProductId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'product': product.toJson(), 
      'quantity': quantity,
      'productId': productId,
    };
  }
}
