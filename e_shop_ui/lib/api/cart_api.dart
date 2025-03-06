// lib/api/cart_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/cart.dart';
import 'package:e_shop_ui/config/api_config.dart';

class CartApi {
  static Future<Cart> getCartByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/carts/user/$userId'),
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  static Future<Cart> addItemToCart(int userId, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/carts/user/$userId/items?productId=$productId&quantity=$quantity'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add item to cart');
    }
  }

  static Future<Cart> updateCartItemQuantity(int userId, int productId, int quantity) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/carts/user/$userId/items?productId=$productId&quantity=$quantity'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update cart item');
    }
  }

  static Future<Cart> removeItemFromCart(int userId, int productId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/carts/user/$userId/items/$productId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to remove item from cart');
    }
  }

  static Future<void> clearCart(int userId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/carts/user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to clear cart');
    }
  }
}