import 'package:flutter/material.dart';

class SocialPostWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final List<String> tags;
  final String userName;
  final String? userProfileImage;

  const SocialPostWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.tags,
    required this.userName,
    this.userProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A), // Dark navy background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Title
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // 3. Description
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // 4. Scrollable Tags List
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tags.map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 5. User Profile Row
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white12,
                backgroundImage: userProfileImage != null
                    ? NetworkImage(userProfileImage!)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
