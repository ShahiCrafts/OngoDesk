import 'package:dartz/dartz.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart'; // Assuming this is the path
import 'package:ongo_desk/features/create_post/domain/repository/category_repository.dart'; // Assuming this is the path

class CategoryFetchUseCase implements UseCaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  CategoryFetchUseCase({required ICategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    // Simply calls the repository method to get all categories and returns the result.
    return _categoryRepository.getAllCategories();
  }
}
