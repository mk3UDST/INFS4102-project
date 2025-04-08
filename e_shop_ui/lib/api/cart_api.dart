import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/cart.dart';
import 'package:e_shop_ui/models/cart_item.dart';
import 'package:e_shop_ui/config/api_config.dart';

class CartApi {
  static final String baseUrl = ApiConfig.baseUrl;

  // Get cart by user ID
  static Future<Cart> getCartByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/carts/user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cart: ${response.statusCode}');
    }
  }

  // Get cart item details
  static Future<CartItem> addItemToCart(int cartId, int productId, int quantity) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/carts/$cartId/items/$productId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return CartItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cart item: ${response.statusCode}');
    }
  }

  // Add item to cart
  static Future<Cart> addToCart(int userId, int productId, int quantity) async {
    print('CartApi.addToCart: userId=$userId, productId=$productId, quantity=$quantity'); // Debug
    
    final response = await http.post(
      Uri.parse('$baseUrl/api/carts/user/$userId/items'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'productId': productId.toString(),
        'quantity': quantity.toString(),
      },
    );

    print('CartApi response status: ${response.statusCode}'); // Debug
    print('CartApi response body: ${response.body}'); // Debug
    
    if (response.statusCode == 200) {
      final cart = Cart.fromJson(json.decode(response.body));
      print('Cart parsed successfully with ${cart.items.length} items'); // Debug
      return cart;
    } else {
      throw Exception('Failed to add item to cart: ${response.body}');
    }
  }

  // Remove item from cart
  static Future<Cart> removeItemFromCart(int userId, int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/carts/user/$userId/items/$productId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to remove item from cart');
    }
  }

  // Get cart item details
  static Future<CartItem> getCartItem(int cartId, int productId) async {
    print('CartApi.getCartItem: cartId=$cartId, productId=$productId'); // Debug
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/carts/$cartId/items/$productId'),
      headers: {'Content-Type': 'application/json'},
    );

    print('CartApi get item response status: ${response.statusCode}'); // Debug
    print('CartApi get item response body: ${response.body}'); // Debug
    
    if (response.statusCode == 200) {
      final cartItem = CartItem.fromJson(json.decode(response.body));
      print('CartItem parsed successfully: id=${cartItem.id}, productId=${cartItem.productId}'); // Debug
      return cartItem;
    } else {
      throw Exception('Failed to load cart item: ${response.statusCode}');
    }
  }

}
