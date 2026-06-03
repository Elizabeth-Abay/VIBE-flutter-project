class RequestsSentToUser {
  // 🔒 Private backing fields
  final String _name;
  final String _userName;
  final String _userId;
  final String? _profileImg;

  RequestsSentToUser({
    required String name,
    required String userName,
    required String userId,
    String? profileImg,
  }) : _name = name,
       _userName = userName,
       _userId = userId,
       _profileImg = profileImg;

  // 🔓 Public Getter Methods

  /// Gets the full display name of the student.
  String get name => _name;

  /// Gets the unique institutional or profile username.
  String get userName => _userName;

  /// Gets the database primary key identifier for the user.
  String get userId => _userId;

  /// Gets the nullable hosted profile avatar image string URL.
  String? get profileImg => _profileImg;
}
