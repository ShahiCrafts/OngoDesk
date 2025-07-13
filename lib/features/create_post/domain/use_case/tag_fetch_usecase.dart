import 'package:dartz/dartz.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/tag_repository.dart';

class TagFetchUseCase implements UseCaseWithoutParams<List<TagEntity>> {
  final ITagRepository _tagRepository;

  TagFetchUseCase({required ITagRepository tagRepository})
    : _tagRepository = tagRepository;

  @override
  Future<Either<Failure, List<TagEntity>>> call() {
    return _tagRepository.getAllTags();
  }
}
