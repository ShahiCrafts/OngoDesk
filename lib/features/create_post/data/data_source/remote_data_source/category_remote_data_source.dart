import 'package:dio/dio.dart';
import 'package:ongo_desk/app/constant/api/api_constant.dart';
import 'package:ongo_desk/core/network/api_service.dart';
import 'package:ongo_desk/features/create_post/data/model/category_api_model.dart'; // Assuming this is the path

/// The abstract interface for the category remote data source.
abstract class ICategoryRemoteDataSource {
  Future<List<CategoryApiModel>> fetchAllCategories();
}

/// The implementation of the remote data source that fetches category data from the API.
class CategoryRemoteDataSource implements ICategoryRemoteDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<CategoryApiModel>> fetchAllCategories() async {
    try {
      // Make the GET request to the server's endpoint for categories.
      final response = await _apiService.dio.get(ApiConstant.fetchCategories); // Ensure this constant exists

      if (response.statusCode == 200) {
        // Assuming the API response is a map with a key 'categories' that holds the list.
        final List<dynamic> categoryListJson = response.data['categories'];
        
        // Map the raw JSON list to a list of CategoryApiModel objects.
        return categoryListJson.map((json) => CategoryApiModel.fromJson(json)).toList();
      } else {
        // Handle non-successful status codes.
        throw Exception('Failed to fetch categories: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      // Handle network-related errors from Dio.
      throw Exception('Failed to fetch categories: ${error.message}');
    } catch (error) {
      // Handle any other unexpected errors.
      throw Exception('Failed to fetch categories: $error');
    }
  }
}
