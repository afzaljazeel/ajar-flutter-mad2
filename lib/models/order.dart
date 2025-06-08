import 'order_item.dart';

class Order {
  final int id;
  final double total;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: double.parse(json['total'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: List<OrderItem>.from(
        json['items'].map((item) => OrderItem.fromJson(item)),
      ),
    );
  }
}
