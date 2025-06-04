import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get total =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  CartProvider() {
    loadCart(); // 🟢 Auto-load on startup
  }

  void addToCart(CartItem item) {
    final existing = _items.indexWhere((e) =>
        e.product.id == item.product.id &&
        e.size == item.size &&
        e.variant == item.variant);

    if (existing != -1) {
      _items[existing].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    saveCart();
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCart();
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.map((e) => e.toJson()).toList();
    prefs.setString('cart', jsonEncode(data));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      _items = decoded.map((e) => CartItem.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
