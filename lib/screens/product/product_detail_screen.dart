import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final void Function()? onThemeToggle;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.onThemeToggle,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedVariant;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, overflow: TextOverflow.ellipsis),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.pushNamed(context, '/wishlist'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
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
                          : product.imagePath;

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Rs. ${product.price.toStringAsFixed(2)}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 24),

                  // Size
                  if (product.sizes != null && product.sizes!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select Size", style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.sizes!
                              .map((size) => ChoiceChip(
                                    label: Text(size),
                                    selected: selectedSize == size,
                                    onSelected: (_) =>
                                        setState(() => selectedSize = size),
                                    selectedColor: theme.colorScheme.primary,
                                    labelStyle: TextStyle(
                                      color: selectedSize == size
                                          ? Colors.white
                                          : null,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  // Variant
                  if (product.variants != null && product.variants!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select Variant",
                            style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.variants!
                              .map((variant) => ChoiceChip(
                                    label: Text(variant),
                                    selected: selectedVariant == variant,
                                    onSelected: (_) => setState(
                                        () => selectedVariant = variant),
                                    selectedColor: theme.colorScheme.primary,
                                    labelStyle: TextStyle(
                                      color: selectedVariant == variant
                                          ? Colors.white
                                          : null,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text("Add to Cart"),
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

                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(
                          product: product,
                          quantity: 1,
                          size: selectedSize,
                          variant: selectedVariant,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
