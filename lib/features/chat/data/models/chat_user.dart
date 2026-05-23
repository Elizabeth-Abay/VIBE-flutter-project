/// Domain + data model for a chat conversation list item.
class ChatUser {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;

  const ChatUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] as String,
      name: json['participant_name'] as String? ??
          json['name'] as String? ??
          'Unknown',
      avatar: json['participant_avatar'] as String? ??
          json['avatar_url'] as String? ??
          '',
      lastMessage: json['last_message'] as String? ?? '',
    );
  }

  factory ChatUser.fromDb(Map<String, dynamic> row) {
    return ChatUser(
      id: row['id'] as String,
      name: row['participant_name'] as String,
      avatar: row['participant_avatar'] as String? ?? '',
      lastMessage: row['last_message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toDb() => {
    'id': id,
    'participant_id': id,
    'participant_name': name,
    'participant_avatar': avatar,
    'last_message': lastMessage,
    'updated_at': DateTime.now().toIso8601String(),
    'cached_at': DateTime.now().toIso8601String(),
  };
}
