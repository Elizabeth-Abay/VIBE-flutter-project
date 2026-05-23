import 'package:flutter/material.dart';
import '../../../../core/utils/image_optimizer.dart';
import '../../../../core/widgets/user_avatar.dart';

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

  /// Optimized Image URL for the main post
  String get optimizedImageUrl =>
      ImageOptimizer.getOptimizedUrl(imageUrl, width: 400, height: 225);

  /// Optimized Profile URL
  String? get optimizedProfileImageUrl => userProfileImageUrl != null
      ? ImageOptimizer.getOptimizedUrl(
          userProfileImageUrl!,
          width: 100,
          height: 100,
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(
          0xFF161A33,
        ), // Updated to match your Figma navy cards
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // 2. Post Image (Using AspectRatio to prevent overflows)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isEmpty
                  ? Container(
                      color: Colors.white10,
                      child: const Icon(
                        Icons.image_outlined,
                        color: Colors.white24,
                      ),
                    )
                  : Image.network(
                      optimizedImageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 400,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white10,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white24,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.white10,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Description
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // 4. Tags List
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tags.map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 5. User Profile Row
          Row(
            children: [
              UserAvatar(
                imageUrl: userProfileImageUrl,
                name: userName,
                radius: 12,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
