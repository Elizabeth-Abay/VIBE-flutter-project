import '../../domain/entity/post_entity.dart';

/// Data-layer model — converts between API JSON, SQLite rows, and PostEntity.
class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    super.imageUrl,
    required super.category,
    required super.userName,
    super.userProfileImageUrl,
    required super.name,
  });

  // ─── From API JSON ───────────────────────────────────────────────────────

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // tags may come as a JSON array string or a real List

    return PostModel(
      id: json['post_id'] as String,
      title: json['title'] as String? ?? 'Untitled',
      description: json['content'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['post_image'] as String?,
      userId: json['author_id'] as String,
      userName: json['user_name'] as String? ?? '',
      name: json['name'] as String,
      userProfileImageUrl: json['author_profile_picture'],
    );
  }

  Map<String, dynamic> toDb() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'description': description,
    'image_url': imageUrl,
    'category': category,
    'user_name': userName,
    'user_profile_image_url': userProfileImageUrl,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'description': description,
    'image_url': imageUrl,
    'category': category,
    'user_name': userName,
    'user_profile_image_url': userProfileImageUrl,
  };
}
