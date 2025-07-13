import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, PostEntity>> createPost(PostEntity post);
  Future<Either<Failure, List<PostEntity>>> getAllPosts({
    int page = 1,
    int limit = 10,
    String? type,
  });
  Future<Either<Failure, PostEntity>> getPostById(String postId);
  Future<Either<Failure, PostEntity>> updatePost(PostEntity post);
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String reason,
  });
}
