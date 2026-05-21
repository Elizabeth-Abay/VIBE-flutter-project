import 'package:flutter/material.dart';
import '../../domain/entity/connected_user.dart';
import 'heart_widget.dart';

/// A single connected user row with live heart toggle.
class ConnectionHolderCell extends StatelessWidget {
  final ConnectedUser user;
  final VoidCallback onHeartTap;

  const ConnectionHolderCell({
    super.key,
    required this.user,
    required this.onHeartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          // Avatar — network image with fallback initial
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF7C3AED).withOpacity(0.3),
            backgroundImage: user.profileImage.startsWith('http')
                ? NetworkImage(user.profileImage)
                : null,
            child: !user.profileImage.startsWith('http')
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 16),

          // Name + username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
              ],
            ),
          ),

          // Heart — state comes from provider, tap goes back to provider
          HeartButton(
            isLiked: user.isLiked,
            onTap: onHeartTap,
          ),
        ],
      ),
    );
  }
}
