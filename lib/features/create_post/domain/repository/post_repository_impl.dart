import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/core/utils/internet_checker.dart';
import 'package:ongo_desk/features/create_post/data/repository/post_remote_repository.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/post_repository.dart';

class PostRepositoryImpl implements IPostRepository {
  final PostRemoteRepository _remoteRepository;
  final InternetChecker _internetChecker;

  PostRepositoryImpl({
    required PostRemoteRepository remoteRepository,
    required InternetChecker internetChecker,
  }) : _remoteRepository = remoteRepository,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, PostEntity>> createPost(
    PostEntity post, {
    List<File> attachments = const [],
  }) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.createPost(post, attachments: attachments);
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts({
    int page = 1,
    int limit = 10,
    String? type,
  }) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.getAllPosts(
        page: page,
        limit: limit,
        type: type,
      );
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(String postId) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.getPostById(postId);
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, PostEntity>> updatePost(
    PostEntity post, {
    List<File> newAttachments = const [],
  }) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.updatePost(post, newAttachments: newAttachments);
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.deletePost(postId);
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String reason,
  }) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.reportPost(postId: postId, reason: reason);
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }
}
