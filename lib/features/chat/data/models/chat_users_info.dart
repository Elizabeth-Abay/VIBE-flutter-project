/// Domain + data model for a chat conversation list item.
class ChatUserInfo{
  final String name;
  final String? profileUrl;
  final String userName;

  const ChatUserInfo({
    required this.name,
    required this.userName,
    this.profileUrl,
  });

  factory ChatUserInfo.fromJson(Map<String, dynamic> json) {
    return ChatUserInfo (
      name: json['name'] as String,
      userName: json['user_name'],
      profileUrl: json['profile_url'] as String?,
    );
  }

  factory ChatUserInfo.fromDb(Map<String, dynamic> row) {
    return ChatUserInfo (
      name: row['name'] as String,
      userName: row['user_name'],
      profileUrl: row['profile_url'] as String?,
    );
  }

  Map<String, dynamic> toDb() => {
    'name': name,
    'user_name': userName,
    'profile_url': profileUrl,
    'updated_at': DateTime.now().toIso8601String(),
    'cached_at': DateTime.now().toIso8601String(),
  };
}
