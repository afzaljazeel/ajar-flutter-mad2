import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black.withOpacity(0.4),
        ),
        child: const Text(
          "Clearance Sale\nUp to 50% Off",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
