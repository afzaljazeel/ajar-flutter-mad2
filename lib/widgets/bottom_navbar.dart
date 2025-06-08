// lib/widgets/bottom_navbar.dart

import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BottomNavigationBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedItemColor: isDark ? Colors.white : Colors.black,
      unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined), label: 'Explore'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
