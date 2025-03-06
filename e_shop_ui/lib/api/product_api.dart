import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/models/product.dart';
import 'package:e_shop_ui/config/api_config.dart';
import 'api_service.dart';

class ProductApi {
  static Future<List<Product>> getAllProducts() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/products/all'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/categories/$categoryId/products'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  static Future<Product> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/products/$id'),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  static Future<List<Product>> searchProducts(String keyword) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/products/search?keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  static Future<List<Product>> filterProducts({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) async {
    try {
      String endpoint = 'products?';

      if (categoryId != null) {
        endpoint += 'categoryId=$categoryId&';
      }

      if (minPrice != null) {
        endpoint += 'minPrice=$minPrice&';
      }

      if (maxPrice != null) {
        endpoint += 'maxPrice=$maxPrice&';
      }

      if (sortBy != null) {
        endpoint += 'sortBy=$sortBy';
      }

      final data = await ApiService.get(endpoint);

      // Check if data is null or empty
      if (data == null) {
        return [];
      }

      if (data is List) {
        return data.map<Product>((json) => Product.fromJson(json)).toList();
      } else {
        print('Expected a list but got: ${data.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error in filterProducts: $e');
      throw Exception('Failed to filter products: $e');
    }
  }

  static Future<List<Product>> getFeaturedProducts() async {
    // This could be a specific endpoint on your backend
    // For now, just return the first few products
    final products = await getAllProducts();
    return products.take(8).toList();
  }
}
