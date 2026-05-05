import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const PostTextField({
    super.key,
    required this.controller,
    this.hintText = "What's on your mind?",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        maxLines: null, // Allows the field to grow vertically
        keyboardType: TextInputType.multiline,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          border: InputBorder.none, // Keeps the UI clean and "Vibe" styled
        ),
      ),
    );
  }
}
