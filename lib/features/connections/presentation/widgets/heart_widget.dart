import 'package:flutter/material.dart';

class HeartButton extends StatefulWidget {
  final String userId;
  final bool initialIsLiked;

  const HeartButton({
    super.key,
    required this.userId,
    required this.initialIsLiked,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.initialIsLiked;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.blue : Colors.white, // Matches image_9fb9f6.png
        size: 32,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        // You can use widget.userId here to trigger a backend update
        print("Toggled like for User ID: ${widget.userId}");
      },
    );
  }
}