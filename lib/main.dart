import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'providers/order_provider.dart';
import 'screens/orders/order_screen.dart';
import 'providers/theme_provider.dart';

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
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
        ChangeNotifierProvider(
            create: (_) => WishlistProvider()..loadWishlist()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..loadOrders()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AJAR',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorSchemeSeed: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors
                  .black, // or Theme.of(context).textTheme.titleLarge?.color dynamically
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Poppins',
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        themeMode: ThemeMode.system, // 🔥 Match system setting
        home: const AuthWrapper(),
        routes: {
          '/cart': (context) => const CartScreen(),
          '/wishlist': (context) => const WishlistScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/orders': (context) => const OrderScreen(),
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
