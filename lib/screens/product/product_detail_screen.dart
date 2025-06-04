import 'package:flutter/material.dart';
import '../../models/product.dart';
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
        actions: const [Icon(Icons.favorite_border)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: product.images?.length ?? 1,
                itemBuilder: (context, index) {
                  final imageUrl =
                      product.images != null && product.images!.isNotEmpty
                          ? product.images![index]
                          : product.displayImage;

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text("Rs. ${product.price.toStringAsFixed(2)}",
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black87)),
                  const SizedBox(height: 20),
                  if (product.sizes != null && product.sizes!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select Size",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          children: product.sizes!
                              .map((size) => ChoiceChip(
                                    label: Text(size),
                                    selected: selectedSize == size,
                                    onSelected: (_) =>
                                        setState(() => selectedSize = size),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  if (product.variants != null && product.variants!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select Variant",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          children: product.variants!
                              .map((variant) => ChoiceChip(
                                    label: Text(variant),
                                    selected: selectedVariant == variant,
                                    onSelected: (_) => setState(
                                        () => selectedVariant = variant),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart =
                            Provider.of<CartProvider>(context, listen: false);
                        cart.addToCart(
                          product,
                          size: selectedSize,
                          variant: selectedVariant,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Add to Cart",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
