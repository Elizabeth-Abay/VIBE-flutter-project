/// Pure domain object for a notification update.
/// No Flutter, no JSON, no DB — just the data the UI needs.
class NotificationEntity {
  final String id;
  final String type; // 'connection_accepted' | 'post_like' | 'mention'
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  /// Returns a copy with [isRead] set to true — used for optimistic mark-read.
  NotificationEntity markAsRead() => NotificationEntity(
    id: id,
    type: type,
    message: message,
    isRead: true,
    createdAt: createdAt,
  );
}

/// Domain object for an incoming connection request shown in the Requests tab.
class ConnectionRequestEntity {
  final String requesterId;
  final String name;
  final String username;
  final String? profileImageUrl;
  final DateTime createdAt;

  const ConnectionRequestEntity({
    required this.requesterId,
    required this.name,
    required this.username,
    this.profileImageUrl,
    required this.createdAt,
  });
}
