import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product, {String? size, String? variant}) {
    // Check if item already exists with same size/variant
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.size == size &&
        item.variant == variant);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product, size: size, variant: variant));
    }

    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get total =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);
}
