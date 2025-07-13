import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';

abstract interface class IPostDataSource {
  Future<PostEntity> createPost(PostEntity post);
  Future<List<PostEntity>> getAllPosts({int page = 1, int limit = 10, String? type});
  Future<PostEntity> getPostById(String postId);
  Future<PostEntity> updatePost(PostEntity post);
  Future<void> deletePost(String postId);
  Future<void> reportPost({required String postId, required String reason});
}
