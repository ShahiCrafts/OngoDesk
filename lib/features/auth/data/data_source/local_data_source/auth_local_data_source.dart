import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/widgets.dart';
import 'package:ongo_desk/core/network/hive_service.dart';
import 'package:ongo_desk/features/auth/data/data_source/auth_data_source.dart';
import 'package:ongo_desk/features/auth/data/model/auth_hive_model.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> sendOtpCode(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtpCode(String email, String otpCode) {
    throw UnimplementedError();
  }

  @override
  Future<void> createAccount(UserEntity user) async {
    try {
      final authHiveModel = AuthHiveModel.fromEntity(user);
      await _hiveService.createAccount(authHiveModel);
    } catch (error) {
      throw Exception('Registration Failed: $error');
    }
  }

  @override
  Future<({UserEntity user, String token})> loginToAccount(
    String email,
    String password,
  ) async {
    try {
      final storedUser = await _hiveService.getUserByEmail(email);

      if (storedUser == null) {
        throw Exception("User not found.");
      }

debugPrint("--- Checking Offline Login ---");
      debugPrint("Password from Form: $password");
      debugPrint("Hashed Password from Hive: ${storedUser.password}");
      final isPasswordCorrect = BCrypt.checkpw(password, storedUser.password!);

      if (isPasswordCorrect) {
        return (user: storedUser.toEntity(), token: 'local_token_placeholder');
      } else {
        throw Exception("Invalid password.");
      }
    } catch (e) {
      throw Exception("Local login failed: $e");
    }
  }

  // Add this temporary method inside your AuthLocalDataSource class

Future<void> runHashIntegrityTest(String email, String plainPassword) async {
  try {
    debugPrint("--- STARTING HASH INTEGRITY TEST ---");

    // 1. Fetch the user we just saved from Hive
    final storedUser = await _hiveService.getUserByEmail(email);

    if (storedUser == null) {
      debugPrint("TEST FAILED: Could not find user '$email' in Hive.");
      return;
    }

    final storedHash = storedUser.password;
    debugPrint("Plain password provided to test: '$plainPassword'");
    debugPrint("Stored hash from Hive: '$storedHash'");

    if (storedHash == null) {
      debugPrint("TEST FAILED: The password stored in Hive is null.");
      return;
    }

    // 2. Perform the bcrypt check
    final bool isCorrect = BCrypt.checkpw(plainPassword, storedHash);

    debugPrint("BCrypt Check Result: $isCorrect");

    if (isCorrect) {
      debugPrint("--- TEST PASSED: The password and hash match correctly! ---");
    } else {
      debugPrint("--- TEST FAILED: BCrypt check returned false. ---");
      debugPrint("This confirms the hash in Hive does not match the plain password.");
    }
  } catch (e) {
    debugPrint("--- HASH INTEGRITY TEST FAILED WITH AN EXCEPTION ---");
    debugPrint(e.toString());
  }
}
}
