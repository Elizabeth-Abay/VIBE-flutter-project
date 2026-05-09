import 'package:flutter/material.dart';


class CancelRequestButton extends StatefulWidget {
  final String userId;
  final bool initialStatus;

  const CancelRequestButton({
    super.key,
    required this.userId,
    required this.initialStatus,
  });

  @override
  State<CancelRequestButton> createState() => _CancelRequestButtonState();
}

class _CancelRequestButtonState extends State<CancelRequestButton> {
  late bool isCancelled;

  @override
  void initState() {
    super.initState();
    isCancelled = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isCancelled = !isCancelled);
        // Clean Architecture: Trigger a UseCase here using widget.userId
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color(0xFFE186FF), Color(0xFF6E85E3)], // Gradient from image
          ),
        ),
        child: Center(
          child: Text(
            isCancelled ? 'Request-Again' : 'Cancel',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}