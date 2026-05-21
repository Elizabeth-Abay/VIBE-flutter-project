import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isArrow;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isArrow ? 60 : double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF40E5), Color(0xFF1F69FF)],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: isArrow
            ? const Icon(Icons.arrow_forward, color: Colors.white)
            : Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
