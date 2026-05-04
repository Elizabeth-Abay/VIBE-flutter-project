class PeopleRecommended{
  final String userId;
  final String displayName;
  final String username;
  final String? userProfileImageUrl;

  PeopleRecommended({
    required this.userId,
    required this.displayName,
    required this.username,
    this.userProfileImageUrl,
  });

}