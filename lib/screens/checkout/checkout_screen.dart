// lib/screens/checkout/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubmitting = false;
  String _currentCity = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _getCurrentCity();
  }

  Future<void> _getCurrentCity() async {
    try {
      final hasPermission = await Geolocator.checkPermission();
      if (hasPermission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          _currentCity = placemarks.first.locality ?? 'Unknown';
        });
      }
    } catch (e) {
      setState(() => _currentCity = 'Location unavailable');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = cart.total;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Delivery Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (value) =>
                    value!.isEmpty ? 'Enter your address' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                  suffixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) => value!.isEmpty ? 'Enter your city' : null,
              ),
              const SizedBox(height: 6),
              Text("📍 Current Location: $_currentCity",
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your phone number' : null,
              ),
              const SizedBox(height: 24),
              const Text("Payment",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                leading: const Icon(Icons.radio_button_checked),
                title: const Text("Cash on Delivery (COD)"),
              ),
              const SizedBox(height: 30),
              Text("Total Payable: Rs. ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSubmitting = true);

                            try {
                              await cart.checkoutWithDetails(
                                name: _nameController.text,
                                address: _addressController.text,
                                city: _cityController.text,
                                phone: _phoneController.text,
                              );

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Order placed successfully!")),
                                );
                                Navigator.pop(context); // Go back to cart
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Order failed")),
                              );
                            } finally {
                              setState(() => _isSubmitting = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Confirm Order",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
