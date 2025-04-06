import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/category.dart';
import 'package:e_shop_ui/config/api_config.dart';

class CategoryApi {
  static Future<List<Category>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/categories/all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = jsonDecode(response.body);
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  static Future<Category> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/categories/$id'),
      );

      if (response.statusCode == 200) {
        return Category.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching category: $e');
      throw Exception('Error fetching category: $e');
    }
  }
}
