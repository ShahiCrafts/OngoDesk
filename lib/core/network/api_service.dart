import 'package:dio/dio.dart';
import 'package:ongo_desk/app/constant/api/api_constant.dart';
import 'package:ongo_desk/core/network/auth_interceptor.dart';
import 'package:ongo_desk/core/network/dio_error_interceptor.dart';
import 'package:ongo_desk/core/network/token_storage_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;
  final TokenStorageService _tokenStorageService;

  Dio get dio => _dio;

  ApiService(this._dio, this._tokenStorageService) {
    _dio
      ..options.baseUrl = ApiConstant.baseUrl
      ..options.connectTimeout = ApiConstant.connectionTimeoutDuration
      ..options.receiveTimeout = ApiConstant.recieveTimeoutDuration
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(AuthInterceptor(_tokenStorageService))
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}
