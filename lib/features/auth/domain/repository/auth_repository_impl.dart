import 'package:dartz/dartz.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/core/utils/internet_checker.dart';
import 'package:ongo_desk/features/auth/data/repository/auth_local_repository.dart';
import 'package:ongo_desk/features/auth/data/repository/auth_remote_repository.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteRepository _remoteRepository;
  final AuthLocalRepository _localRepository;
  final InternetChecker _internetChecker;

  AuthRepositoryImpl({
    required AuthRemoteRepository remoteRepository,
    required AuthLocalRepository localRepository,
    required InternetChecker internetChecker,
  }) : _remoteRepository = remoteRepository,
       _localRepository = localRepository,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, void>> createAccount(UserEntity user) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.createAccount(user);
    } else {
      return Left(
        ApiFailure(message: 'Please, Check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> loginToAccount(
    String email,
    String password,
  ) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.loginToAccount(email, password);
    } else {
      return _localRepository.loginToAccount(email, password);
    }
  }

  @override
  Future<Either<Failure, void>> sendOtpToEmail(String email) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.sendOtpToEmail(email);
    } else {
      return Left(
        ApiFailure(message: 'Please, Check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otpCode) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      return _remoteRepository.verifyOtp(email, otpCode);
    } else {
      return Left(
        ApiFailure(message: 'Please, Check your internet connection.'),
      );
    }
  }
}
