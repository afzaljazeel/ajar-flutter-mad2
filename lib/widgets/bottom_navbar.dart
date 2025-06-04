// lib/widgets/bottom_navbar.dart

import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
