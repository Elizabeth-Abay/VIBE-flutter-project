import 'package:vibe_app/features/profiles/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.name,
    required super.userName,
    required super.userId,
    required super.email,
    required super.vibes,
    super.profileUrl,
    super.bio,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> parseVibes(dynamic raw) {
      if (raw == null) return {};
      if (raw is Map) {
        return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
      return {};
    }

    return ProfileModel(
      // Maps backend keys safely to your requested local property names
      name: json['name'] as String? ?? json['display_name'] as String? ?? '',
      userName: json['user_name'] as String? ?? json['username'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bio: json['bio'] as String?,
      profileUrl: json['profile_url'] as String? ?? json['avatar_url'] as String?,
      vibes: parseVibes(json['vibes']),
    );
  }

  ProfileModel copyWith({
    String? name,
    String? userName,
    String? userId,
    String? email,
    String? bio,
    String? profileUrl,
    Map<String, String>? vibes,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileUrl: profileUrl ?? this.profileUrl,
      vibes: vibes ?? this.vibes,
    );
  }
}