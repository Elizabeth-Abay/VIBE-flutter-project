/// Pure domain object — no Flutter, no JSON, no DB logic.
/// This is what the rest of the app works with.
class UserEntity {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    required this.createdAt,
  });
}
