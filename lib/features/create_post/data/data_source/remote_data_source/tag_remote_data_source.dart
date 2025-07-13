import 'package:dio/dio.dart';
import 'package:ongo_desk/app/constant/api/api_constant.dart';
import 'package:ongo_desk/core/network/api_service.dart';
import 'package:ongo_desk/features/create_post/data/model/tag_api_model.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';

abstract class ITagRemoteDataSource {
  Future<List<TagApiModel>> fetchAllTags();
  Future<void> updateTag(TagEntity tag);
}

class TagRemoteDataSource implements ITagRemoteDataSource {
  final ApiService _apiService;

  TagRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<TagApiModel>> fetchAllTags() async {
    try {
      final response = await _apiService.dio.get(ApiConstant.fetchTags);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        final List<dynamic> tagListJson = responseData['tags'];
        return tagListJson.map((json) => TagApiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch tags: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('Failed to fetch tags: ${error.message}');
    } catch (error) {
      throw Exception('Failed to fetch tags: $error');
    }
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    // This method remains the same
    if (tag.id == null) {
      throw Exception('Tag id is required for update');
    }
    try {
      final tagApiModel = TagApiModel.fromEntity(tag);
      final response = await _apiService.dio.put(
        '${ApiConstant.updateTags}/${tag.id}',
        data: tagApiModel.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update tag: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('Failed to update tag: ${error.message}');
    } catch (error) {
      throw Exception('Failed to update tag: $error');
    }
  }
}