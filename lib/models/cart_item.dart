import 'product.dart';

class CartItem {
  final Product product;
  final String? size;
  final String? variant;
  int quantity;

  CartItem({
    required this.product,
    this.size,
    this.variant,
    this.quantity = 1,
  });
}
