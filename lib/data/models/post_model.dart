class PostModel {
  final String category;
  final String status;
  final String postedAt;
  final String postedBy;
  final String content;
  final String upVoteCount;
  final String downVoteCount;
  final String imageUri;
  final String profileUri;

  PostModel({
    required this.category,
    required this.status,
    required this.postedAt,
    required this.postedBy,
    required this.content,
    required this.upVoteCount,
    required this.downVoteCount,
    required this.imageUri,
    required this.profileUri
  });
}
