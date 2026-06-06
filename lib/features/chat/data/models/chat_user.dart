/// Domain + data model for a chat conversation list item.
class ChatUser {
  final String chatId;
  final String chatWith;
  final String name;
  final String? profileUrl;
  final String userName;

  const ChatUser({
    required this.chatId,
    required this.chatWith,
    required this.name,
    required this.userName,
    this.profileUrl,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      chatId: json['chat_id'] as String,
      chatWith: json['participant_id'],
      name: json['name'] as String,
      userName: json['user_name'],
      profileUrl: json['profile_url'] as String?,
    );
  }

  factory ChatUser.fromDb(Map<String, dynamic> row) {
    return ChatUser(
      chatId: row['chat_id'] as String,
      chatWith: row['participant_id'] as String,
      name: row['name'] as String,
      userName: row['user_name'],
      profileUrl: row['profile_url'] as String?,
    );
  }

  Map<String, dynamic> toDb() => {
    'chat_id': chatId,
    'participant_id': chatWith,
    'name': name,
    'user_name': userName,
    'profile_url': profileUrl,
    'updated_at': DateTime.now().toIso8601String(),
    'cached_at': DateTime.now().toIso8601String(),
  };
}
