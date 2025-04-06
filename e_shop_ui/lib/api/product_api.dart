import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/product.dart';
import 'package:e_shop_ui/config/api_config.dart';

class ProductApi {
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/products/all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/products/$id'),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product: $e');
      throw Exception('Error fetching product: $e');
    }
  }

  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/products/category/$categoryId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonDecode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load products by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      throw Exception('Error fetching products by category: $e');
    }
  }

  static Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }

  static Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/products/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}
