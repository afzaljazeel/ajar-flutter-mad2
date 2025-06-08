// lib/providers/order_provider.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _service = OrderService();

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _service.fetchOrders();
    } catch (e) {
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
