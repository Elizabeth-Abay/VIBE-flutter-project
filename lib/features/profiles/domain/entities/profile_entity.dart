/// Domain entity for the current user's full profile.
class ProfileEntity {
  final String name;
  final String userName;
  final String userId;
  final String email; // Kept because repository requires it
  final String? bio;
  final String? profileUrl;
  final Map<String, String> vibes; // Kept because repository requires it

  const ProfileEntity({
    required this.name,
    required this.userName,
    required this.userId,
    required this.email,
    required this.vibes,
    this.profileUrl,
    this.bio,
  });
}
