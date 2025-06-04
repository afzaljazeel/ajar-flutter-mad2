import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart'; // Make sure this exists
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';

void main() {
  runApp(const AJARApp());
}

class AJARApp extends StatelessWidget {
  const AJARApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()..checkLoginStatus()),
        ChangeNotifierProvider(
            create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AJAR',
        theme: ThemeData(
          fontFamily: 'Poppins',
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),
        home: const AuthWrapper(),
        routes: {
          '/cart': (context) => const CartScreen(),
          '/wishlist': (context) => const WishlistScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}
