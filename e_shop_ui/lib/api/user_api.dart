import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/user.dart';
import 'package:e_shop_ui/config/api_config.dart';

class UserApi {
  static Future<User> getUserById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/users/$id'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<User> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  static Future<User> updateUser(int id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }
}
