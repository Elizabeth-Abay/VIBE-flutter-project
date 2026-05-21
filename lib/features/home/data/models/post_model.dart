import 'dart:convert';
import '../../domain/entity/post_entity.dart';

/// Data-layer model — converts between API JSON, SQLite rows, and PostEntity.
class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    super.imageUrl,
    required super.tags,
    required super.category,
    required super.userName,
    super.userProfileImageUrl,
    required super.createdAt,
  });

  // ─── From API JSON ───────────────────────────────────────────────────────

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // tags may come as a JSON array string or a real List
    List<String> parseTags(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) return List<String>.from(raw);
      try {
        return List<String>.from(jsonDecode(raw as String));
      } catch (_) {
        return [];
      }
    }

    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      tags: parseTags(json['tags']),
      category: json['category'] as String? ?? 'General',
      userName: json['user_name'] as String? ?? 'Unknown',
      userProfileImageUrl: json['user_profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // ─── From SQLite row ─────────────────────────────────────────────────────

  factory PostModel.fromDb(Map<String, dynamic> row) {
    return PostModel(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      imageUrl: row['image_url'] as String?,
      tags: row['tags'] != null
          ? List<String>.from(jsonDecode(row['tags'] as String))
          : [],
      category: row['category'] as String? ?? 'General',
      userName: row['user_name'] as String? ?? 'Unknown',
      userProfileImageUrl: row['user_profile_image_url'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Map<String, dynamic> toDb() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'tags': jsonEncode(tags),
        'category': category,
        'user_name': userName,
        'user_profile_image_url': userProfileImageUrl,
        'created_at': createdAt.toIso8601String(),
        'cached_at': DateTime.now().toIso8601String(),
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'tags': tags,
        'category': category,
        'user_name': userName,
        'user_profile_image_url': userProfileImageUrl,
        'created_at': createdAt.toIso8601String(),
      };
}
