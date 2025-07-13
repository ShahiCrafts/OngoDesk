import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/tag_repository.dart';

class UpdateTagParams extends Equatable {
  final String id;
  final TagEntity updatedTag;

  const UpdateTagParams({required this.id, required this.updatedTag});

  @override
  List<Object?> get props => [id, updatedTag];
}

class UpdateTagUseCase implements UseCaseWithParams<void, UpdateTagParams> {
  final ITagRepository _tagRepository;

  UpdateTagUseCase({required ITagRepository tagRepository})
    : _tagRepository = tagRepository;

  @override
  Future<Either<Failure, void>> call(UpdateTagParams params) {
    return _tagRepository.updateTag(params.id, params.updatedTag);
  }
}
