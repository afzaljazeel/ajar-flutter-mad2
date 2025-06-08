// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../home/home_tab.dart';
import '../orders/order_screen.dart';
import '../profile/profile_screen.dart';
import '../explore/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isDarkMode = false;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const HomeTab(),
      const ExploreScreen(),
      const OrderScreen(),
      ProfileScreen(
        onThemeToggle: toggleTheme,
      ),
    ]);
  }

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
