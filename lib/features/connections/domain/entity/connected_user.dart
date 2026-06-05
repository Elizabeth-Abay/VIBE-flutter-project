class ConnectedUser {
  final String userId;
  final String name;
  final String username;
  final String? profileImage;

  ConnectedUser({
    required this.userId,
    required this.name,
    required this.username,
    this.profileImage,
    isLiked = false,
  });

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
      // Maps keys based on your backend connection payload layout
      userId: json['user_id'] as String,
      name: json['name'] as String,
      username: json['user_name'] as String,
      profileImage: json['profile_url'] as String?,
    );
  }
}
