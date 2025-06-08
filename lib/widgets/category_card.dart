// lib/widgets/category_card.dart
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
