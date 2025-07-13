import 'package:bcrypt/bcrypt.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
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
      final remoteResult = await _remoteRepository.createAccount(user);

      return remoteResult.fold((failure) => Left(failure), (_) async {
        final String hashedPassword = BCrypt.hashpw(
          user.password!,
          BCrypt.gensalt(),
        );
        
        debugPrint("--- Hashing on Register ---");
        debugPrint("Original Password: ${user.password}");
        debugPrint("Hashed Password to be saved locally: $hashedPassword");
        
        final userWithHashedPassword = UserEntity(
          id: user.id,
          username: user.username,
          fullName: user.fullName,
          email: user.email,
          password: hashedPassword,
          googleId: user.googleId,
          role: user.role,
          emailVerified: user.emailVerified,
          isBanned: user.isBanned,
          isActive: user.isActive,
          notificationPreferences: user.notificationPreferences,
          ogdPoints: user.ogdPoints,
          bio: user.bio,
          location: user.location,
          profileImage: user.profileImage,
          lastLogin: user.lastLogin,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        );

        await _localRepository.createAccount(userWithHashedPassword);

        return const Right(null);
      });
    } else {
      return Left(
        ApiFailure(message: 'Please, Check your internet connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, ({UserEntity user, String token})>> loginToAccount(
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
