import '../../domain/entity/requests_sent_to_user.dart';

class RequestsSentToUserModel extends RequestsSentToUser {
  RequestsSentToUserModel({
    required super.name,
    required super.userName,
    required super.userId,
    super.profileImg,
  });

  /// Factory constructor to parse the raw JSON data returned from the SQL query
  factory RequestsSentToUserModel.fromJson(Map<String, dynamic> json) {
    return RequestsSentToUserModel(
      name: json['name'] as String? ?? 'Unknown User',
      userName: json['user_name'] as String? ?? 'unknown',
      userId: json['user_id'] as String? ?? '',
      profileImg:
          json['profile_url']
              as String?, // Maps directly to profileImg entity field
    );
  }

  /// Converts the model back into a JSON map structured payload if needed
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user_name': userName,
      'user_id': userId,
      'profile_url': profileImg,
    };
  }
}
