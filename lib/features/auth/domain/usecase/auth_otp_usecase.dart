import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ongo_desk/app/use_case/use_case.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';

class SendOtpUsecase implements UseCaseWithParams<void, String> {
  final IAuthRepository _authRepository;
  SendOtpUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(String email) =>
      _authRepository.sendOtpToEmail(email);
}

class VerifyOtpParams extends Equatable {
  final String email;
  final String code;

  const VerifyOtpParams({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}

class VerifyOtpUsecase implements UseCaseWithParams<void, VerifyOtpParams> {
  final IAuthRepository _authRepository;
  VerifyOtpUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) =>
      _authRepository.verifyOtp(params.email, params.code);
}
