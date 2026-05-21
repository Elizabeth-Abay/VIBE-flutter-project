/// Domain entity for a notification item.
class NotificationEntity {
  final String id;
  final String
      type; // 'connection_accepted' | 'connection_request' | 'post_like'
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
}

/// Incoming connection request shown in the Requests tab.
class ConnectionRequestEntity {
  final String requesterId;
  final String name;
  final String? profileImage;
  final DateTime createdAt;

  const ConnectionRequestEntity({
    required this.requesterId,
    required this.name,
    this.profileImage,
    required this.createdAt,
  });
}
