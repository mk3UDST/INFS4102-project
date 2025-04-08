import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/cart.dart';
import 'package:e_shop_ui/models/cart_item.dart';
import 'package:e_shop_ui/config/api_config.dart';

class CartApi {
  static Future<Cart> getCartByUserId(int userId) async {
    try {
      // Use the cart endpoint with query parameters for complete product details
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/carts/user/$userId?includeProducts=true',
        ),
      );

      if (response.statusCode == 200) {
        // Debug print to see the response structure
        print('Cart response: ${response.body}');
        return Cart.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart: $e');
      throw Exception('Error fetching cart: $e');
    }
  }

  static Future<Cart> addItemToCart(
    int userId,
    int productId,
    int quantity,
  ) async {
    try {
      // Debugging: Log the request details
      print(
        'Adding item to cart: userId=$userId, productId=$productId, quantity=$quantity',
      );

      // Use query parameters instead of JSON body if required by the backend
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/carts/user/$userId/items?productId=$productId&quantity=$quantity',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      // Debugging: Log the response details
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Cart.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to add item to cart: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error adding item to cart: $e');
      throw Exception('Error adding item to cart: $e');
    }
  }

  static Future<Cart> updateCartItemQuantity(
    int userId,
    int productId,
    int quantity,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/carts/user/$userId/items/$productId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        return Cart.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update cart item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart item: $e');
      throw Exception('Error updating cart item: $e');
    }
  }

  static Future<void> removeItemFromCart(int userId, int productId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/carts/user/$userId/items/$productId',
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to remove item from cart: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error removing item from cart: $e');
      throw Exception('Error removing item from cart: $e');
    }
  }

  static Future<void> clearCart(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/carts/user/$userId/clear'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Error clearing cart: $e');
    }
  }
}
