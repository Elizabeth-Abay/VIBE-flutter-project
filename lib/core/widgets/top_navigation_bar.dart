import 'package:flutter/material.dart';

class VibeTopNavBar extends StatelessWidget {
  /// The local path to your 'Vibe' logo in assets.
  final String logoAssetPath = 'assets/images/image.png';
  
  /// Callback triggered when the notification bell is tapped.
  final VoidCallback onNotificationTap;
  
  /// Callback triggered when the profile icon is tapped.
  final VoidCallback onConnectionsTap;

  const VibeTopNavBar({
    super.key,
    required this.onNotificationTap,
    required this.onConnectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    // Top bar height matches typical screen patterns (e.g., 60-70px).
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color.fromARGB(255, 10, 11, 16), // Match the dark Navy background from image_0.png
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Vibe Logo Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              logoAssetPath,
              fit: BoxFit.contain,
              // The image provides its own glow, so we don't need additional decoration here.
            ),
          ),
          
          // 2. Icon Action Section
          Row(
            children: [
              // Notification Bell (Glow Effect on tap)
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_outlined, 
                  color: Color(0xFFFFD700), // Gold/Yellow from image_1.png
                  size: 28,
                ),
                splashRadius: 24, // Subtle glow on tap
              ),
              const SizedBox(width: 8), // Minimal spacing between icons
              
              // Profile/Connections (Avatar with subtle style)
              GestureDetector(
                onTap: onConnectionsTap,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08), // Subtle background
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF90CAF9), // Subtle blue from image_1.png
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}