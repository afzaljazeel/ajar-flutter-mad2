// lib/services/wishlist_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/product.dart';

class WishlistService {
  Future<List<Product>> fetchWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Missing token');

    final response = await http.get(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('📥 Wishlist API status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load wishlist');
    }
  }

  Future<void> toggleWishlist(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Missing token');

    final response = await http.post(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {'product_id': product.id.toString()},
    );

    print('🔁 Toggle wishlist status: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle wishlist');
    }
  }
}
