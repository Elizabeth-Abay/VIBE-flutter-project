import 'package:flutter/material.dart';
import '../../../../core/utils/image_optimizer.dart';

class SocialPostWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final List<String> tags;
  final String userName;
  final String? userProfileImageUrl;

  const SocialPostWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.tags,
    required this.userName,
    this.userProfileImageUrl,
  });

  /// Gets optimized image URL for faster loading
  String get optimizedImageUrl => ImageOptimizer.getOptimizedUrl(imageUrl);
  
  /// Gets optimized profile image URL
  String? get optimizedProfileImageUrl => 
      userProfileImageUrl != null ? ImageOptimizer.getOptimizedUrl(userProfileImageUrl!) : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0 , 16.0 , 16.0 , 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A), // Dark navy background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header Title
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Post Image
          Container(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                optimizedImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white54,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Description
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
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
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                backgroundImage: optimizedProfileImageUrl != null
                    ? NetworkImage(optimizedProfileImageUrl!)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
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
