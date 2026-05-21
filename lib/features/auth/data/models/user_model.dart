import '../../domain/entities/user_entity.dart';

/// Data-layer model: knows how to convert to/from JSON and SQLite maps.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.bio,
    super.avatarUrl,
    required super.createdAt,
  });

  // ─── From API JSON ───────────────────────────────────────────────────────

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'bio': bio,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
      };

  // ─── From SQLite row ─────────────────────────────────────────────────────

  factory UserModel.fromDb(Map<String, dynamic> row) {
    return UserModel(
      id: row['id'] as String,
      username: row['username'] as String,
      email: row['email'] as String,
      bio: row['bio'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Map<String, dynamic> toDb() => {
        'id': id,
        'username': username,
        'email': email,
        'bio': bio,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
      };
}
