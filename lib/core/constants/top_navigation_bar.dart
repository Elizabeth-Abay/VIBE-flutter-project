import 'package:flutter/material.dart';

class VibeTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const VibeTopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D1B2A), // Dark theme matching Vibe
      elevation: 0,
      title: Row(
        children: [
          // The Vibe Logo
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFD98BF5), Color(0xFF7B72EF)],
            ).createShader(bounds),
            child: const Text(
              'Vibe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Notification Bell
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFFFFD700), // Gold/Yellow bell from image
            size: 28,
          ),
        ),
        // Profile Icon
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.person_pin,
            color: Color(0xFF8C9EF0), // Muted blue profile icon
            size: 28,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}