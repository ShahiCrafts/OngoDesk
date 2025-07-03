import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';

  Future<void> saveToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _accessTokenKey);
  }
}
