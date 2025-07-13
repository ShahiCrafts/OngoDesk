import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';
import 'package:ongo_desk/features/create_post/domain/repository/post_repository.dart';

class CreatePostParams extends Equatable {
  final PostEntity post;

  const CreatePostParams({required this.post});

  @override
  List<Object?> get props => [post];
}

class CreatePostUsecase
    implements UseCaseWithParams<PostEntity, CreatePostParams> {
  final IPostRepository _repository;

  CreatePostUsecase({required IPostRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, PostEntity>> call(CreatePostParams params) {
    return _repository.createPost(params.post);
  }
}
