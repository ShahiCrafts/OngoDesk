import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/data/data_source/post_data_source.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/post_repository.dart';

class PostRemoteRepository implements IPostRepository {
  final IPostDataSource _remoteDataSource;

  PostRemoteRepository({required IPostDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, PostEntity>> createPost(
    PostEntity post, {
    List<File> attachments = const [],
  }) async {
    try {
      final created = await _remoteDataSource.createPost(post);
      return Right(created);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts({
    int page = 1,
    int limit = 10,
    String? type,
  }) async {
    try {
      final posts = await _remoteDataSource.getAllPosts(
        page: page,
        limit: limit,
        type: type,
      );
      return Right(posts);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(String postId) async {
    try {
      final post = await _remoteDataSource.getPostById(postId);
      return Right(post);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> updatePost(
    PostEntity post, {
    List<File> newAttachments = const [],
  }) async {
    try {
      final updated = await _remoteDataSource.updatePost(post);
      return Right(updated);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await _remoteDataSource.deletePost(postId);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String reason,
  }) async {
    try {
      await _remoteDataSource.reportPost(postId: postId, reason: reason);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
