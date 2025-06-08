// lib/screens/home/home_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/category_card.dart';
import '../../widgets/product_card.dart';
import '../../widgets/offline_banner.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _goToExplore(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      '/explore',
      arguments: {'category': category},
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products.take(8).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'AJAR',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context)
              .iconTheme
              .color, // applies to cart/wishlist icons
        ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OfflineBanner(),
            const HomeBanner(),
            const SizedBox(height: 24),
            const Text("We Specialized In",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                CategoryCard(
                  title: 'Shoes',
                  imagePath: 'assets/images/shoes_bg.jpg',
                  onTap: () => _goToExplore(context, 'Shoes'),
                ),
                CategoryCard(
                  title: 'Perfumes',
                  imagePath: 'assets/images/perfumes_bg.jpg',
                  onTap: () => _goToExplore(context, 'Perfumes'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text("Top Picks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (productProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) =>
                    ProductCard(product: products[index]),
              ),
          ],
        ),
      ),
    );
  }
}
