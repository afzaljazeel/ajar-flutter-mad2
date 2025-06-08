// lib/services/cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  Future<List<CartItem>> fetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<CartItem>.from(data.map((item) => CartItem.fromJson(item)));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<void> addToCart({
    required Product product,
    required int quantity,
    String? size,
    String? variant,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'product_id': product.id.toString(),
        'quantity': quantity.toString(),
        'size': size ?? '',
        'variant': variant ?? '',
      },
    );
  }

  Future<void> removeFromCart(int cartItemId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await http.delete(
      Uri.parse('$baseUrl/cart/$cartItemId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }
}
