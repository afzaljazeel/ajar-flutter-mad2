import 'product.dart';

class OrderItem {
  final Product product;
  final int quantity;
  final String? size;
  final String? variant;
  final double price;

  OrderItem({
    required this.product,
    required this.quantity,
    this.size,
    this.variant,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      size: json['size'],
      variant: json['variant'],
      price: double.parse(json['price'].toString()),
    );
  }
}
