// lib/screens/profile/profile_screen.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../config.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;

  const ProfileScreen({super.key, this.onThemeToggle});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _imageFile;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final Battery _battery = Battery();
  int? _batteryLevel;
  BatteryState? _batteryState;
  final Connectivity _connectivity = Connectivity();
  String _connectionStatus = 'Unknown';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _initBattery();
    _initConnectivity();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
      });
    }
  }

  Future<void> _initBattery() async {
    _batteryLevel = await _battery.batteryLevel;
    _batteryState = await _battery.batteryState;
    setState(() {});
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result.toString().split('.').last;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/user/update'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = _nameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['phone'] = _phoneController.text;
    if (_passwordController.text.isNotEmpty) {
      request.fields['password'] = _passwordController.text;
    }
    if (_imageFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profile_image', _imageFile!.path));
    }

    final response = await request.send();
    final resBody = await http.Response.fromStream(response);
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            response.statusCode == 200 ? 'Profile updated' : 'Update failed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text("Gallery"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("Camera"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage('assets/images/avatar.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'New Password'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _updateProfile,
                        icon: const Icon(Icons.save),
                        label: const Text("Save"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.battery_charging_full),
                      title: Text("Battery: $_batteryLevel%"),
                      subtitle:
                          Text("Status: ${_batteryState?.name ?? 'Unknown'}"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.wifi),
                      title: Text("Connectivity: $_connectionStatus"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
