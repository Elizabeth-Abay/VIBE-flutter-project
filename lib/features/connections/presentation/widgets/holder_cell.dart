import 'package:flutter/material.dart';
import '../../domain/entity/connected_user.dart';
import 'heart_widget.dart';
import 'message_button.dart';

/// A single connected user row — profile image, name, username, heart.
class ConnectionHolderCell extends StatelessWidget {
  final ConnectedUser user;

  const ConnectionHolderCell({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          // Avatar — network image with local asset fallback
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white12,
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == ''
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 16),

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
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Heart — now driven by Riverpod state
          HeartButton(userId: user.userId, initialIsLiked: false),
          MessageButton(userId: user.userId),
        ],
      ),
    );
  }
}
