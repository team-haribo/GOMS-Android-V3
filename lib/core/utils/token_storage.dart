import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 토큰 저장소
class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _accessTokenExpiryKey = 'access_token_expiry';
  static const _refreshTokenExpiryKey = 'refresh_token_expiry';

  /// Access Token 저장
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Refresh Token 저장
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Access Token 만료 시각 저장
  static Future<void> saveAccessTokenExpiry(DateTime expiresAt) async {
    await _storage.write(
      key: _accessTokenExpiryKey,
      value: expiresAt.toUtc().toIso8601String(),
    );
  }

  /// Refresh Token 만료 시각 저장
  static Future<void> saveRefreshTokenExpiry(DateTime expiresAt) async {
    await _storage.write(
      key: _refreshTokenExpiryKey,
      value: expiresAt.toUtc().toIso8601String(),
    );
  }

  /// Access Token 불러오기
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Refresh Token 불러오기
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Access Token 만료 시각 불러오기
  static Future<DateTime?> getAccessTokenExpiry() async {
    final value = await _storage.read(key: _accessTokenExpiryKey);
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toUtc();
  }

  /// Refresh Token 만료 시각 불러오기
  static Future<DateTime?> getRefreshTokenExpiry() async {
    final value = await _storage.read(key: _refreshTokenExpiryKey);
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toUtc();
  }

  /// 모든 토큰 삭제 (로그아웃)
  static Future<void> deleteAllTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _accessTokenExpiryKey);
    await _storage.delete(key: _refreshTokenExpiryKey);
  }

  /// 모든 저장된 데이터 삭제
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
