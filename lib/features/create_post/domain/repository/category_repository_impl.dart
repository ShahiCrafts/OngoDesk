import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/core/utils/internet_checker.dart';
import 'package:ongo_desk/features/create_post/data/repository/category_remote_repository.dart'; // Assuming this is the path
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/category_repository.dart'; // Assuming this is the path

class CategoryRepositoryImpl implements ICategoryRepository {
  final CategoryRemoteRepository _remoteRepository;
  final InternetChecker _internetChecker;

  CategoryRepositoryImpl({
    required CategoryRemoteRepository remoteRepository,
    required InternetChecker internetChecker,
  })  : _remoteRepository = remoteRepository,
        _internetChecker = internetChecker;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    // First, check if the device has an active internet connection.
    final isOnline = await _internetChecker.isConnected();
    
    if (isOnline) {
      // If online, proceed to fetch the categories from the remote repository.
      return _remoteRepository.getAllCategories();
    } else {
      // If offline, return a Failure object with a user-friendly message.
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }
}
