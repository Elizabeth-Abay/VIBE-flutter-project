class PostFetchObj {
  final String title;
  final String? imageUrl;
  final String description;
  final List<String>? tags;
  final String userName;
  final String? userProfileImageUrl;

  PostFetchObj({
    required this.title,
    this.imageUrl,
    required this.description,
    this.tags,
    required this.userName,
    this.userProfileImageUrl
  });
}
