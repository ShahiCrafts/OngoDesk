import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/category_repository.dart'; // Assuming this is the path

class CategoryRemoteRepository implements ICategoryRepository {
  final ICategoryRemoteDataSource _categoryRemoteDataSource;

  CategoryRemoteRepository({required ICategoryRemoteDataSource categoryRemoteDataSource})
      : _categoryRemoteDataSource = categoryRemoteDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      // 1. Call the data source to fetch the raw API models.
      final categoryModels = await _categoryRemoteDataSource.fetchAllCategories();
      
      // 2. Convert the list of API models to a list of domain entities.
      final categories = categoryModels.map((model) => model.toEntity()).toList();
      
      // 3. Return the list of entities wrapped in 'Right' on success.
      return Right(categories);
    } catch (error) {
      // 4. If any error occurs, wrap it in a 'Failure' object and return it in 'Left'.
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
