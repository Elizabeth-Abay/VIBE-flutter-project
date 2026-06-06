import 'package:flutter/material.dart';

/// Simple interactive Heart Button that updates its visual color immediately when tapped.
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
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    // Initialize our local state with the value passed from the parent widget
    _isLiked = widget.initialIsLiked;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked
            ? const Color(0xFFE186FF)
            : Colors.white, // Custom accent pop color
        size: 28,
      ),
      onPressed: () {
        setState(() {
          // Instantly toggle the local state variable on tap
          _isLiked = !_isLiked;
        });
      },
    );
  }
}
