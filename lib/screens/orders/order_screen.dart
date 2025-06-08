import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
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
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.orders.isEmpty
              ? const Center(child: Text("No orders yet."))
              : ListView.builder(
                  itemCount: orderProvider.orders.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final Order order = orderProvider.orders[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order #${order.id}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(
                                    order.status.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 82, 82, 82),
                                ),
                                Text(
                                  "Rs. ${order.total.toStringAsFixed(2)}",
                                  style: theme.textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              "Placed on ${order.createdAt.toLocal().toString().split(' ')[0]}",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ...order.items.map((item) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: Image.network(
                                    item.product.imagePath,
                                    width: 48,
                                    height: 48,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image),
                                  ),
                                  title: Text(item.product.name),
                                  subtitle: Text(
                                    "Size: ${item.size ?? 'N/A'} | Variant: ${item.variant ?? 'N/A'}\nQty: ${item.quantity}",
                                    style: theme.textTheme.bodySmall,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
