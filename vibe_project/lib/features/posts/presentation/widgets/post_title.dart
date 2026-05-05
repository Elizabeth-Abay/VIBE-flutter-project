import 'package:flutter/material.dart';

class PostTitleField extends StatelessWidget {
  final TextEditingController controller;

  const PostTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        maxLines: 1, // Titles are typically single-line
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24, // Larger font for the title
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "Enter Title...",
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 24,
          ),
          border: InputBorder.none, // Clean look matching your theme
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
