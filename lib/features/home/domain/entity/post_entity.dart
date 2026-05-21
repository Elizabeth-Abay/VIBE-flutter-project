/// Full domain entity for a post.
/// Adds id, userId, category and timestamps to the shape
/// already used in PostFetchObj — needed for SQLite caching.
class PostEntity {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  final String category;
  final String userName;
  final String? userProfileImageUrl;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.tags,
    required this.category,
    required this.userName,
    this.userProfileImageUrl,
    required this.createdAt,
  });
}
