import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Assumes you're using go_router for navigation

class MessageButton extends StatelessWidget {
  final String userId;

  const MessageButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Navigates to /chat-detail/916393d9-c5ae-40ed-8f19-9df5b9b418e1
        context.push('/chat-detail/$userId');
      },
      icon: const Icon(
        Icons.chat_bubble_outline_rounded,
        color: Color(0xFFBB86FC), // Accent purple matching your theme
        size: 24,
      ),
      tooltip: 'Message User',
    );
  }
}
