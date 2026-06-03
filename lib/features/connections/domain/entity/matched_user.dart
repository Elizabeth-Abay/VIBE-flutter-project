class MatchedUser {
  final String id;
  final String name;
  final String username;
  final String? avatarUrl;

  const MatchedUser({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl,
  });

  factory MatchedUser.fromJson(Map<String, dynamic> json) {
    return MatchedUser(
      id: json['user_id'] as String,
      name: json['name'] as String,
      username: json['user_name'] as String,
      avatarUrl: json['profile_url'] as String?, // Maps to your 'profile_url' key
    );
  }
}