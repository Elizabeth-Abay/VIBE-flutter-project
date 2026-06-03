class ConnectedUser {
  final String userId;
  final String name;
  final String username;
  final String profileImage;

  ConnectedUser({
    required this.userId,
    required this.name,
    required this.username,
    required this.profileImage,
    isLiked = false,
  });

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
      // Maps keys based on your backend connection payload layout
      userId: json['user_id'] as String? ?? json['id'] as String? ?? '',
      name:
          json['name'] as String? ??
          json['display_name'] as String? ??
          'Unknown',
      username:
          json['user_name'] as String? ?? json['username'] as String? ?? '',
      profileImage: json['profile_url'] as String,
    );
  }
}
