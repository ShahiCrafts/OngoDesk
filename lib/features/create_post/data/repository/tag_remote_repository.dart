import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/data/data_source/remote_data_source/tag_remote_data_source.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/tag_repository.dart';

class TagRemoteRepository implements ITagRepository {
  final ITagRemoteDataSource _tagRemoteDataSource;

  TagRemoteRepository({required ITagRemoteDataSource tagRemoteDataSource})
    : _tagRemoteDataSource = tagRemoteDataSource;

  @override
  Future<Either<Failure, List<TagEntity>>> getAllTags() async {
    try {
      final tagModels = await _tagRemoteDataSource.fetchAllTags();
      final tags = tagModels.map((model) => model.toEntity()).toList();
      return Right(tags);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTag(String id, TagEntity tag) async {
    try {
      await _tagRemoteDataSource.updateTag(tag);
      return const Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
