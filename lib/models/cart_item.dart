import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? size;
  final String? variant;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size,
    this.variant,
  });

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'image': product.image,
        },
        'quantity': quantity,
        'size': size,
        'variant': variant,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final p = json['product'];
    return CartItem(
      product: Product(
        id: p['id'],
        name: p['name'],
        price: double.parse(p['price'].toString()),
        image: p['image'],
        sizes: p['sizes'],
        variants: p['variants'],
      ),
      quantity: json['quantity'],
      size: json['size'],
      variant: json['variant'],
    );
  }
}
