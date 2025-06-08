class Product {
  final int id;
  final String name;
  final double price;
  final List<String>? sizes;
  final List<String>? variants;
  final String imagePath;
  final List<String> images;
  final String? category;
  final double? salePrice;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.sizes,
    this.variants,
    this.images = const [],
    this.category,
    this.salePrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse image list and extract cover
    List<String> allImages = [];
    String? coverImage;

    if (json['images'] != null && json['images'] is List) {
      final rawImages = json['images'] as List;
      allImages = rawImages
          .map((img) {
            if (img is String) return img;
            return img['image_path'] ?? '';
          })
          .toList()
          .cast<String>();

      final cover = rawImages.firstWhere(
        (img) => img is Map && img['is_cover'] == 1,
        orElse: () => null,
      );
      if (cover != null && cover['image_path'] != null) {
        coverImage = cover['image_path'];
      }
    }

    return Product(
      id: json['id'],
      name: json['name'],
      salePrice: json['sale_price'] != null
          ? double.tryParse(json['sale_price'].toString())
          : null,
      price: double.tryParse(json['sale_price']?.toString() ??
              json['price']?.toString() ??
              '0') ??
          0,
      imagePath:
          coverImage ?? json['image'] ?? 'https://via.placeholder.com/150',
      sizes: (json['sizes'] as List?)?.map((e) => e.toString()).toList(),
      variants: (json['variants'] as List?)?.map((e) => e.toString()).toList(),
      images: allImages,
      category: json['category']?['name'],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imagePath: $imagePath}';
  }
}
