import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 토큰 저장소
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /// Access Token 저장
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Refresh Token 저장
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Access Token 불러오기
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Refresh Token 불러오기
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// 모든 토큰 삭제 (로그아웃)
  static Future<void> deleteAllTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// 모든 저장된 데이터 삭제
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
