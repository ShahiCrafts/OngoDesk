import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ongo_desk/app/constant/api/api_constant.dart';
import 'package:ongo_desk/core/network/api_service.dart';
import 'package:ongo_desk/features/create_post/data/data_source/post_data_source.dart';
import 'package:ongo_desk/features/create_post/data/model/post_api_model.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';

class PostRemoteDataSource implements IPostDataSource {
  final ApiService _apiService;

  PostRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<PostEntity> createPost(PostEntity post, {List<File> attachments = const []}) async {
    try {
      final formData = FormData.fromMap({
        ...PostApiModel.fromEntity(post).toJson(),
        if (attachments.isNotEmpty)
          'attachments': [
            for (final file in attachments)
              await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          ],
      });

      final response = await _apiService.dio.post(
        ApiConstant.createPost,
        data: formData,
      );

      if (response.statusCode == 201) {
        return PostApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception('Failed to create post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Create post failed: ${e.message}');
    }
  }

  @override
  Future<List<PostEntity>> getAllPosts({int page = 1, int limit = 10, String? type}) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstant.getAllPosts,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (type != null) 'type': type,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['posts'];
        return data.map((json) => PostApiModel.fromJson(json).toEntity()).toList();
      } else {
        throw Exception('Failed to fetch posts: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Fetch posts failed: ${e.message}');
    }
  }

  @override
  Future<PostEntity> getPostById(String postId) async {
    try {
      final response = await _apiService.dio.get('${ApiConstant.getPostById}/$postId');

      if (response.statusCode == 200) {
        return PostApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception('Failed to get post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Get post failed: ${e.message}');
    }
  }

  @override
  Future<PostEntity> updatePost(PostEntity post, {List<File> newAttachments = const []}) async {
    if (post.id == null) throw Exception('Post ID is required for update');

    try {
      final formData = FormData.fromMap({
        ...PostApiModel.fromEntity(post).toJson(),
        if (newAttachments.isNotEmpty)
          'attachments': [
            for (final file in newAttachments)
              await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          ],
      });

      final response = await _apiService.dio.put(
        '${ApiConstant.updatePost}/${post.id}',
        data: formData,
      );

      if (response.statusCode == 200) {
        return PostApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception('Failed to update post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Update post failed: ${e.message}');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final response = await _apiService.dio.delete('${ApiConstant.deletePost}/$postId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Delete post failed: ${e.message}');
    }
  }

  @override
  Future<void> reportPost({required String postId, required String reason}) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstant.flagReported,
        data: {'postId': postId, 'reason': reason},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to report post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Report post failed: ${e.message}');
    }
  }
}
