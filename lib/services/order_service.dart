// lib/services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/order.dart';

class OrderService {
  Future<List<Order>> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Order>.from(data.map((item) => Order.fromJson(item)));
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
