import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/core/utils/internet_checker.dart';
import 'package:ongo_desk/features/create_post/data/repository/tag_remote_repository.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/tag_repository.dart';

class TagRepositoryImpl implements ITagRepository {
  final TagRemoteRepository _remoteRepository;
  final InternetChecker _internetChecker;

  TagRepositoryImpl({
    required TagRemoteRepository remoteRepository,
    required InternetChecker internetChecker,
  }) : _remoteRepository = remoteRepository,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, List<TagEntity>>> getAllTags() async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.getAllTags();
    } else {
      return Left(
        ApiFailure(message: 'Please, check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTag(String id, TagEntity tag) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.updateTag(id, tag);
    } else {
      return Left(ApiFailure(message: 'Cannot update tag while offline.'));
    }
  }
}
