import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthDataSource {
  Future<void> sendOtpCode(String email);
  Future<void> verifyOtpCode(String email, String otpCode);
  Future<void> createAccount(UserEntity user);
  Future<String> loginToAccount(String email, String password);
}