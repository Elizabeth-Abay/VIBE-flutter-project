import 'package:flutter/material.dart';

class VibeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VibeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B2A), // Your dark navy background
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo Section
              Row(
                children: [
                  Image.asset(
                    'assets/images/vibe_logo.png', // Ensure this path exists
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Vibe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              // Actions Section
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Notification logic
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.white),
                    onPressed: () {
                      // Profile logic
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Adjust based on SafeArea
}
