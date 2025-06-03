// lib/models/product.dart
class Product {
  final int id;
  final String name;
  final double price;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: double.parse(json['price'].toString()),
    );
  }

  String get displayImage => (image != null && image!.isNotEmpty)
      ? image!.replaceFirst('localhost', '127.0.0.1') // 🔥 critical fix
      : 'https://via.placeholder.com/150';
}
