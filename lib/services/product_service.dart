// lib/services/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('PRODUCT API STATUS: ${response.statusCode}');
      print('PRODUCT API BODY: ${response.body}');
      return List<Product>.from(data.map((item) => Product.fromJson(item)));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
