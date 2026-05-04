import 'package:flutter/material.dart';

class CategoryPill extends StatelessWidget {
  final String label;
  final String icon; // This can be an emoji string or a path to an image
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12), // Space between pills
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Dark background matching your UI
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(30), // High radius for pill shape
          border: Border.all(
            // Purple border seen in the image
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF8B5CF6).withOpacity(0.5),
            width: 1.5,
          ),
          // Subtle glow if selected
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon/Emoji section
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            // Label section
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
