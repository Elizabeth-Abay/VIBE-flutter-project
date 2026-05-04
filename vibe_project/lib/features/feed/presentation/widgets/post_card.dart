import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  // this creates horizontally scrollable posts

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with author info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '@${post.authorUsername}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey[600]),
              ],
            ),
          ),
          // Post image
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: post.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                ),
              ),
            ),
          // Post content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.content,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Categories
                Wrap(
                  spacing: 6,
                  children: post.categories.map((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Engagement stats
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${post.likes}', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 16),
                    Icon(Icons.comment_outlined, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${post.comments}', style: TextStyle(color: Colors.grey[600])),
                    const Spacer(),
                    Icon(Icons.share_outlined, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 16),
                    Icon(Icons.bookmark_border, size: 20, color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
