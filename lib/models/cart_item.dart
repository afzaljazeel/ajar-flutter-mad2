// lib/models/cart_item.dart
import 'product.dart';

class CartItem {
  final int id;
  final Product product;
  final int quantity;
  final String? size;
  final String? variant;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.size,
    this.variant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      size: json['size'],
      variant: json['variant'],
    );
  }
}
