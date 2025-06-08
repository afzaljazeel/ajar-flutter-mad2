import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'dart:convert'; // for jsonEncode
import 'package:http/http.dart' as http; // for API calls
import 'package:shared_preferences/shared_preferences.dart'; // for token
import '../config.dart'; // for baseUrl

class CartProvider with ChangeNotifier {
  final CartService _service = CartService();
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  double get total {
    return _items.fold(0, (sum, item) {
      final price = item.product.salePrice ?? item.product.price;
      return sum + (price * item.quantity);
    });
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _service.fetchCart();
    } catch (e) {
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart({
    required Product product,
    required int quantity,
    String? size,
    String? variant,
  }) async {
    await _service.addToCart(
      product: product,
      quantity: quantity,
      size: size,
      variant: variant,
    );

    await loadCart(); // refresh
  }

  Future<void> removeFromCart(int id) async {
    await _service.removeFromCart(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> checkoutWithDetails({
    required String name,
    required String address,
    required String city,
    required String phone,
  }) async {
    try {
      final payload = {
        'name': name,
        'address': address,
        'city': city,
        'phone': phone,
        'items': _items
            .map((item) => {
                  'product_id': item.product.id,
                  'size': item.size,
                  'variant': item.variant,
                  'quantity': item.quantity,
                  'price': item.product.salePrice ?? item.product.price,
                })
            .toList(),
      };

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _items.clear();
        notifyListeners();
      } else {
        throw Exception('Failed to checkout: ${response.body}');
      }
    } catch (e) {
      print('❌ Checkout failed: $e');
      rethrow;
    }
  }
}
