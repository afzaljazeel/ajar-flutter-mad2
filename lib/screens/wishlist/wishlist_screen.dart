import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Load wishlist after widget is built
    Future.microtask(() =>
        Provider.of<WishlistProvider>(context, listen: false).loadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: wishlist.isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlist.items.isEmpty
              ? const Center(child: Text("Your wishlist is empty"))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: wishlist.items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: wishlist.items[index]);
                  },
                ),
    );
  }
}
