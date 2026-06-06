import '../../domain/entity/notification_entity.dart';

/// Data-layer model — converts between API JSON, SQLite rows,
/// and the pure [NotificationEntity] domain object.
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.message,
    required super.isRead,
    required super.createdAt,
  });

  // ─── From API JSON ───────────────────────────────────────────────────────

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      isRead: (json['is_read'] == true || json['is_read'] == 1),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // ─── From SQLite row ─────────────────────────────────────────────────────

  factory NotificationModel.fromDb(Map<String, dynamic> row) {
    return NotificationModel(
      id: row['id'] as String,
      type: row['type'] as String,
      message: row['message'] as String,
      isRead: (row['is_read'] as int) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Map<String, dynamic> toDb() => {
    'id': id,
    'type': type,
    'message': message,
    'is_read': isRead ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'cached_at': DateTime.now().toIso8601String(),
  };
}

/// Data model for an incoming connection request.
class ConnectionRequestModel extends ConnectionRequestEntity {
  const ConnectionRequestModel({
    required super.requesterId,
    required super.name,
    required super.username,
    super.profileImageUrl,
    required super.createdAt,
  });

  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ConnectionRequestModel(
      requesterId: (json['user_id'] ?? json['requester_id'] ?? '') as String,
      name: (json['name'] ?? json['display_name'] ?? 'Unknown User') as String,
      username: (json['user_name'] ?? json['username'] ?? '') as String,
      profileImageUrl: (json['profile_url'] ?? json['avatar_url'] ?? json['profile_image_url']) as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  factory ConnectionRequestModel.fromDb(Map<String, dynamic> row) {
    return ConnectionRequestModel(
      requesterId: row['requester_id'] as String,
      name: row['name'] as String,
      username: row['username'] as String,
      profileImageUrl: row['profile_image_url'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Map<String, dynamic> toDb() => {
    'requester_id': requesterId,
    'name': name,
    'username': username,
    'profile_image_url': profileImageUrl,
    'created_at': createdAt.toIso8601String(),
    'cached_at': DateTime.now().toIso8601String(),
  };
}
