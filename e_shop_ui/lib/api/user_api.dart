import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/user.dart';
import 'package:e_shop_ui/config/api_config.dart';

class UserApi {
  static Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/users'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

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

  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  static Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/users/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
