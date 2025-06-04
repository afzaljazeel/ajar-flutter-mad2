import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/cart_item.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedVariant;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.favorite_border),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 320,
              child: PageView.builder(
                itemCount: product.images?.length ?? 1,
                itemBuilder: (context, index) {
                  final imageUrl =
                      (product.images != null && product.images!.isNotEmpty)
                          ? product.images![index]
                          : product.displayImage;

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rs. ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (product.sizes != null && product.sizes!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Size",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.sizes!
                              .map((size) => ChoiceChip(
                                    label: Text(size),
                                    selected: selectedSize == size,
                                    onSelected: (_) =>
                                        setState(() => selectedSize = size),
                                    selectedColor: Colors.black,
                                    labelStyle: TextStyle(
                                      color: selectedSize == size
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  if (product.variants != null && product.variants!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Variant",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.variants!
                              .map((variant) => ChoiceChip(
                                    label: Text(variant),
                                    selected: selectedVariant == variant,
                                    onSelected: (_) => setState(
                                        () => selectedVariant = variant),
                                    selectedColor: Colors.black,
                                    labelStyle: TextStyle(
                                      color: selectedVariant == variant
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (product.sizes != null &&
                            product.sizes!.isNotEmpty &&
                            selectedSize == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select a size")),
                          );
                          return;
                        }

                        if (product.variants != null &&
                            product.variants!.isNotEmpty &&
                            selectedVariant == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select a variant")),
                          );
                          return;
                        }

                        final cart =
                            Provider.of<CartProvider>(context, listen: false);
                        cart.addToCart(
                          CartItem(
                            product: product,
                            size: selectedSize,
                            variant: selectedVariant,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart!")),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
