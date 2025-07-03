import 'package:dio/dio.dart';
import 'token_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageService _tokenStorageService;

  AuthInterceptor(this._tokenStorageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _tokenStorageService.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _tokenStorageService.deleteToken();
    }
    handler.next(err);
  }
}
