class SentRequestUser {
  final String userId;
  final String name;
  final String profileImage;
  final String timestamp; // e.g., "2m ago"
  bool isCancelled;

  SentRequestUser({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.timestamp,
    this.isCancelled = false,
  });
}