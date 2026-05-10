class ConnectedUser {
  final String userId;
  final String name;
  final String username;
  final String profileImage;
  bool isLiked; // This tracks if the heart should be blue or white

  ConnectedUser({
    required this.userId,
    required this.name,
    required this.username,
    required this.profileImage,
    this.isLiked = false,
  });
}
