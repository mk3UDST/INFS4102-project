import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/order.dart';
import 'package:e_shop_ui/config/api_config.dart';

class OrderApi {
  static Future<List<Order>> getOrdersByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/orders/user/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = jsonDecode(response.body);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<Order> getOrderById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/orders/$id'),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load order');
    }
  }

  static Future<Order> createOrderFromCart(int userId, String shippingAddress, String paymentMethod) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/orders/create-from-cart/$userId'),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  static Future<Order> updateOrderStatus(int id, String status) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/orders/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order status');
    }
  }

  static Future<void> deleteOrder(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/orders/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete order');
    }
  }
}
