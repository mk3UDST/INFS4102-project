// lib/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_shop_ui/config/api_config.dart';

class ApiService {
  static Future<dynamic> get(String endpoint) async {
    final url = '${ApiConfig.baseUrl}/api/$endpoint';
    print('Making GET request to: $url'); // Debug logging

    try {
      final response = await http.get(Uri.parse(url));

      print('Response status code: ${response.statusCode}');
      if (response.body.isNotEmpty) {
        print(
          'Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...',
        );
      } else {
        print('Response body is empty');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return [];
        }

        try {
          return jsonDecode(response.body);
        } catch (e) {
          print('JSON decode error: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('API request error: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create data: ${response.statusCode}');
    }
  }

  static Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  static Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }
}
