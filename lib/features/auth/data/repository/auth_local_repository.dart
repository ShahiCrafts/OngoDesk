import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository({ required AuthLocalDataSource authLocalDataSource }) : _authLocalDataSource = authLocalDataSource;

  @override
  Future<Either<Failure, void>> createAccount(UserEntity user) async {
    try {
      await _authLocalDataSource.createAccount(user);
      return Right(null);
    } catch (error) {
      return Left(LocalDatabaseFailure(message: 'User Registration Failed!: $error'));
    }
  }
  
  @override
  Future<Either<Failure, ({UserEntity user, String token})>> loginToAccount(String email, String password) async {
    try {
      final result = await _authLocalDataSource.loginToAccount(
        email,
        password,
      );
      return Right(result);
    } catch(error) {
      return Left(LocalDatabaseFailure(message: 'Login Failed! $error'));
    }
  }
  
  @override
  Future<Either<Failure, void>> sendOtpToEmail(String email) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otpCode) {
    throw UnimplementedError();
  }
}