import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/core/network/auth_service.dart';
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
  final AuthService _authService;

  AuthLoginUsecase({
    required IAuthRepository authRepository,
    required AuthService authService,
  })  : _authRepository = authRepository,
        _authService = authService;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await _authRepository.loginToAccount(
      params.email,
      params.password,
    );

    return await result.fold(
      (failure) async => Left(failure),
      (data) async {
        final user = data.user;
        final token = data.token;

        await _authService.signIn(user, token);
        return Right(token);
      },
    );
  }
}
