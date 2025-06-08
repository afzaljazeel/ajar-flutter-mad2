import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class ExploreScreen extends StatefulWidget {
  final String? categoryFromNav;
  final void Function()? onThemeToggle;

  const ExploreScreen({super.key, this.categoryFromNav, this.onThemeToggle});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String selectedCategory;
  String selectedSort = 'Default';

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryFromNav ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    final filtered = selectedCategory == 'All'
        ? products
        : products.where((p) {
            final cat = p.category?.toLowerCase() ?? '';
            return cat == selectedCategory.toLowerCase();
          }).toList();

    if (selectedSort == 'Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == 'High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.pushNamed(context, '/wishlist'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort Filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: const Icon(Icons.sort),
                      value: selectedSort,
                      items: ['Default', 'Low to High', 'High to Low']
                          .map((sort) =>
                              DropdownMenuItem(value: sort, child: Text(sort)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedSort = value!),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) =>
                        ProductCard(product: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
