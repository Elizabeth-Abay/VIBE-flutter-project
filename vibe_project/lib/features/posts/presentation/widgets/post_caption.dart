import 'package:flutter/material.dart';

class PostCaptionHeader extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onPost;
  final String userName;
  final String? profileImageUrl;

  const PostCaptionHeader({
    super.key,
    required this.onCancel,
    required this.onPost,
    required this.userName,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                backgroundColor: Colors.white12,
              ),
              const SizedBox(width: 8),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B72EF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: const Text('Post', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
