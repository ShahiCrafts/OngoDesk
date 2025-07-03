import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';

class AuthRegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const AuthRegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  const AuthRegisterParams.initial({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}


class AuthRegisterUsecase implements UseCaseWithParams<void, AuthRegisterParams>{

  final IAuthRepository _authRepository;

  AuthRegisterUsecase({ required IAuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(AuthRegisterParams params) {
    final userEntity = UserEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password
    );

    return _authRepository.createAccount(userEntity);
  }
}