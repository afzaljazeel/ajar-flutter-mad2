// lib/widgets/category_card.dart
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryCard({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
