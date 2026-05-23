import 'package:flutter/material.dart';

class VibeTopNavBar extends StatelessWidget {
  final String logoAssetPath = 'assets/images/image.png';
  final VoidCallback onNotificationTap;
  final VoidCallback onConnectionsTap;

  const VibeTopNavBar({
    super.key,
    required this.onNotificationTap,
    required this.onConnectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 10, 11, 16),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 100,
                  child: Image.asset(
                    logoAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text(
                      'Vibe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onNotificationTap,
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFFFFD700),
                    size: 26,
                  ),
                ),
                GestureDetector(
                  onTap: onConnectionsTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      color: Color(0xFF90CAF9),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
