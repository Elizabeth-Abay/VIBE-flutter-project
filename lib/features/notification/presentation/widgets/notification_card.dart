import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String text;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.text,
    required this.time,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRead ? Colors.white10 : const Color(0xFF1E1040),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead
                ? Colors.transparent
                : const Color(0xFF7C3AED).withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            // Unread dot
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFBB86FC),
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Text(
                '$text • $time',
                style: TextStyle(
                  color: isRead ? Colors.white60 : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
