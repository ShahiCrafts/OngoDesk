import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart'; // Assuming this is the path

abstract interface class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}
