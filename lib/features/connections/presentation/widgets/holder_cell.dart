import 'package:flutter/material.dart';
import 'heart_widget.dart';
import '../../domain/entity/connected_user.dart';

class ConnectionHolderCell extends StatelessWidget {
  final ConnectedUser user;

  const ConnectionHolderCell({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(user.profileImage),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 16),

          // User Details
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
                  user.username,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Heart Action Widget
          HeartButton(userId: user.userId, initialIsLiked: user.isLiked),
        ],
      ),
    );
  }
}
