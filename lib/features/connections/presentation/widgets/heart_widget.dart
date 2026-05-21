import 'package:flutter/material.dart';

/// Stateless heart button — state lives in the Riverpod notifier, not here.
class HeartButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const HeartButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.blueAccent : Colors.white,
        size: 32,
      ),
      onPressed: onTap,
    );
  }
}
