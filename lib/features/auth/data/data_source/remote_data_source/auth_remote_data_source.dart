import 'package:dio/dio.dart';
import 'package:ongo_desk/app/constant/api/api_constant.dart';
import 'package:ongo_desk/core/network/api_service.dart';
import 'package:ongo_desk/features/auth/data/data_source/auth_data_source.dart';
import 'package:ongo_desk/features/auth/data/model/auth_api_model.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final ApiService _apiService;

  AuthRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> sendOtpCode(String email) async {
    print('Sending OTP to email: $email'); // Make sure email is not empty

    try {
      final response = await _apiService.dio.post(
        ApiConstant.sendOtpCode,
        data: {'email': email},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('Send OTP failed: ${error.message}');
    } catch (error) {
      throw Exception('Send OTP failed: $error');
    }
  }

  @override
  Future<void> verifyOtpCode(String email, String otpCode) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstant.verifyOtpCode,
        data: {'email': email, 'code': otpCode},
      );

      if (response.statusCode != 200) {
        throw Exception('OTP verification failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('OTP verification failed: ${error.message}');
    } catch (error) {
      throw Exception('OTP verification failed: $error');
    }
  }

  @override
  Future<void> createAccount(UserEntity user) async {
    try {
      final authApiModel = AuthApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiConstant.register,
        data: authApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('User registration failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('User registration failed: ${error.message}');
    } catch (error) {
      throw Exception('User registration failed: $error');
    }
  }

  @override
  Future<({UserEntity user, String token})> loginToAccount(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstant.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final userEntity = UserEntity.fromJson(response.data['user']);
        final token = response.data['token'] as String;

        return (user: userEntity, token: token);
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('Login failed: ${error.message}');
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }
}
