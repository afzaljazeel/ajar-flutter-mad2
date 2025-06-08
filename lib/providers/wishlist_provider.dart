import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistService _service = WishlistService();
  List<Product> _items = [];
  bool _isLoading = false;

  List<Product> get items => _items;
  bool get isLoading => _isLoading;

  bool isFavorite(Product product) {
    return _items.any((p) => p.id == product.id);
  }

  Future<void> loadWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _service.fetchWishlist();
      print('✅ Wishlist loaded: ${_items.length} items');
    } catch (e) {
      print('❌ Wishlist error: $e');
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      await _service.toggleWishlist(product);

      // Refresh wishlist from server after toggle
      await loadWishlist();
    } catch (e) {
      print('❌ Toggle wishlist failed: $e');
    }
  }
}
