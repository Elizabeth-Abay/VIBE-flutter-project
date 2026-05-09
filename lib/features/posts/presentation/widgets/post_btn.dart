import 'package:flutter/material.dart';

class VibePostButton extends StatelessWidget {
  final VoidCallback onTap;

  const VibePostButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          // Stadium border gives it that perfectly rounded pill shape
          borderRadius: BorderRadius.circular(30), 
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF19AF3), // Soft pink/purple on the left
              Color(0xFF8C9EF0), // Muted blue/purple on the right
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: const Text(
          'Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}