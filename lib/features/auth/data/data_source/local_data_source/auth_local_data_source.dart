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
    } catch(error) {
      throw Exception('Registration Failed: $error');
    }
  }
  
  @override
  Future<String> loginToAccount(String email, String password) async {
    try {
      final userData = await _hiveService.login(email, password);
      if (userData != null && userData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
