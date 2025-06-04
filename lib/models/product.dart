// lib/models/product.dart
class Product {
  final int id;
  final String name;
  final double price;
  final String? image;
  final List<String>? sizes;
  final List<String>? variants;
  final List<String>? images;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.sizes,
    required this.variants,
    this.image,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],
      variants:
          json['variants'] != null ? List<String>.from(json['variants']) : [],
      price: double.parse(json['price'].toString()),
    );
  }
  // 🌐 Platform-aware image URL handling
  String get displayImage {
    if (image == null || image!.isEmpty) {
      return 'https://via.placeholder.com/150';
    }

    // 🌐 Platform-aware fix
    if (image!.contains('localhost')) {
      return image!.replaceFirst('localhost', '10.0.2.2'); // Android emulator
    } else if (image!.contains('127.0.0.1')) {
      return image!;
    } else if (image!.startsWith('/storage')) {
      return 'http://127.0.0.1:8000${image!}';
    }

    return image!;
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, image: $image}';
  }
}
