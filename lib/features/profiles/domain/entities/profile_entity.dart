/// Domain entity for the current user's full profile.
class ProfileEntity {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final List<String> interests;
  final Map<String, String> vibes; // interest → Love/Like/Neutral/Bothered/Hate

  const ProfileEntity({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.interests = const [],
    this.vibes = const {},
  });

  ProfileEntity copyWith({
    String? username,
    String? bio,
    String? avatarUrl,
    List<String>? interests,
    Map<String, String>? vibes,
  }) {
    return ProfileEntity(
      id: id,
      email: email,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interests: interests ?? this.interests,
      vibes: vibes ?? this.vibes,
    );
  }
}
