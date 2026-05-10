import 'package:flutter/material.dart';
import 'connect_button.dart';
import '../../domain/entity/connection_request_sending_result.dart';

class UserConnectionCard extends StatelessWidget {
  final String userId;
  final String displayName;
  final String username;
  final String? userProfileImageUrl;
  final Future<ConnectResult> Function(String userId) onConnect;
  // ConnectResult is a data transfer object defined in the entity part

  const UserConnectionCard({
    super.key,
    required this.userId,
    required this.displayName,
    required this.username,
    this.userProfileImageUrl,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          _UserAvatar(userProfileImageUrl: userProfileImageUrl, displayName: displayName),
          const SizedBox(width: 12),

          // Name + Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@$username',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Connect button — receives userId and the injected backend function
          ConnectButton(userId: userId, onConnect: onConnect),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? userProfileImageUrl;
  final String displayName;

  const _UserAvatar({this.userProfileImageUrl, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFF7C3AED).withOpacity(0.3),
      backgroundImage: userProfileImageUrl != null ? NetworkImage(userProfileImageUrl!) : null,
      child: userProfileImageUrl == null
          ? Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          : null,
    );
  }
}
