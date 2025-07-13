import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> sendOtpToEmail(String email);
  Future<Either<Failure, void>> verifyOtp(String email, String otpCode);
  Future<Either<Failure, void>> createAccount(UserEntity user);
  Future<Either<Failure, ({UserEntity user, String token})>> loginToAccount(String email, String password);
}