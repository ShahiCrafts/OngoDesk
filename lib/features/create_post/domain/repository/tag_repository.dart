import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';

abstract interface class ITagRepository {
  Future<Either<Failure, List<TagEntity>>> getAllTags();
  Future<Either<Failure, void>> updateTag(String id, TagEntity tag);
}
