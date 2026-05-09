import 'package:flutter/material.dart';

class AnimatedHeartWidget extends StatefulWidget {
  const AnimatedHeartWidget({super.key});

  @override
  State<AnimatedHeartWidget> createState() => _AnimatedHeartWidgetState();
}

class _AnimatedHeartWidgetState extends State<AnimatedHeartWidget> {
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(isLiked),
          color: isLiked ? Colors.red : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}