import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: items.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final CartItem item = items[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            item.product.imagePath,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                          title: Text(item.product.name),
                          subtitle: Text(
                            "Size: ${item.size ?? 'N/A'} | Variant: ${item.variant ?? 'N/A'}\nQty: ${item.quantity}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => cart.removeFromCart(item.id),
                          ),
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${item.product.name} removed from cart."),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Rs. ${cart.total.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout');
                      },
                      child: const Text("Checkout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
