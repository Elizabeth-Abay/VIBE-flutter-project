import '../../domain/entity/recommended_people_fetch_obj.dart';

class RecommendedUserModel extends PeopleRecommended {
  RecommendedUserModel({
    required super.userId,
    required super.displayName,
    required super.username,
    super.userProfileImageUrl,
  });

  factory RecommendedUserModel.fromJson(Map<String, dynamic> json) {
    return RecommendedUserModel(
      userId: json['id'] as String? ?? json['user_id'] as String,
      displayName: json['display_name'] as String,
      username: json['username'] as String,
      userProfileImageUrl: json['avatar_url'] as String?,
    );
  }

  factory RecommendedUserModel.fromDb(Map<String, dynamic> row) {
    return RecommendedUserModel(
      userId: row['user_id'] as String,
      displayName: row['display_name'] as String,
      username: row['username'] as String,
      userProfileImageUrl: row['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toDb() => {
    'user_id': userId,
    'display_name': displayName,
    'username': username,
    'avatar_url': userProfileImageUrl,
    'cached_at': DateTime.now().toIso8601String(),
  };
}
