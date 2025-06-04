// lib/services/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/product.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProductService {
  Future<List<Product>> fetchProducts() async {
    try {
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
        return List<Product>.from(data.map((item) => Product.fromJson(item)));
      } else {
        throw Exception('API Error');
      }
    } catch (e) {
      print('⚠️ API failed, using local fallback. Error: $e');
      final localJson =
          await rootBundle.loadString('assets/data/fallback_products.json');
      final data = json.decode(localJson);
      return List<Product>.from(data.map((item) => Product.fromJson(item)));
    }
  }
}
