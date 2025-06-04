import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _wishlist = [];

  List<Product> get items => _wishlist; // ✅ Use 'items' to match UI usage

  WishlistProvider() {
    loadWishlist();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    saveWishlist();
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _wishlist.any((p) => p.id == product.id);
  }

  Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _wishlist
        .map((p) => {
              'id': p.id,
              'name': p.name,
              'price': p.price,
              'image': p.image,
              'sizes': p.sizes,
              'variants': p.variants,
            })
        .toList();
    prefs.setString('wishlist', jsonEncode(data));
  }

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('wishlist');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      _wishlist = decoded.map((p) => Product.fromJson(p)).toList();
      notifyListeners();
    }
  }
}
