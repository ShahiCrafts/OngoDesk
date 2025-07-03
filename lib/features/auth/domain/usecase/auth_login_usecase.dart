import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/core/network/token_storage_service.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  const LoginParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class AuthLoginUsecase implements UseCaseWithParams<String, LoginParams> {
  final IAuthRepository _authRepository;
  final TokenStorageService _tokenStorageService;

  AuthLoginUsecase({
    required IAuthRepository authRepository,
    required TokenStorageService tokenStorageService,
  })  : _authRepository = authRepository,
        _tokenStorageService = tokenStorageService;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await _authRepository.loginToAccount(
      params.email,
      params.password,
    );

    return await result.fold(
      (failure) async => Left(failure),
      (authToken) async {
        await _tokenStorageService.saveToken(authToken);
        return Right(authToken);
      },
    );
  }
}
