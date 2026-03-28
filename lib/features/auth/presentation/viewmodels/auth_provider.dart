import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/data/providers/auth_data_providers.dart';

/// 인증 상태
enum AuthStatus {
  /// 인증되지 않음
  unauthenticated,

  /// 인증됨
  authenticated,

  /// 확인 중
  checking,
}

/// 인증 상태 provider
final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(() {
  return AuthNotifier();
});

/// 인증 Notifier
class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.checking;

  /// 토큰 유효성 확인
  Future<bool> checkToken() async {
    state = AuthStatus.checking;
    final accessToken = await TokenStorage.getAccessToken();
    final accessTokenExpiry = await TokenStorage.getAccessTokenExpiry();

    if (_hasValidToken(accessToken, accessTokenExpiry)) {
      state = AuthStatus.authenticated;
      return true;
    }

    final refreshToken = await TokenStorage.getRefreshToken();
    final refreshTokenExpiry = await TokenStorage.getRefreshTokenExpiry();

    if (!_hasValidToken(refreshToken, refreshTokenExpiry)) {
      await TokenStorage.deleteAllTokens();
      state = AuthStatus.unauthenticated;
      return false;
    }

    try {
      final response = await ref.read(authRepositoryProvider).reissue(
            refreshToken: refreshToken!,
          );
      await TokenStorage.saveAccessToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveAccessTokenExpiry(response.accessTokenExpiresIn);
      await TokenStorage.saveRefreshTokenExpiry(response.refreshTokenExpiresIn);
      state = AuthStatus.authenticated;
      return true;
    } on DioException catch (_) {
      await TokenStorage.deleteAllTokens();
      state = AuthStatus.unauthenticated;
      return false;
    } catch (_) {
      await TokenStorage.deleteAllTokens();
      state = AuthStatus.unauthenticated;
      return false;
    }
  }

  /// 로그인 완료 처리
  void setAuthenticated() {
    state = AuthStatus.authenticated;
  }

  /// 로그아웃
  Future<void> logout() async {
    await TokenStorage.deleteAllTokens();
    state = AuthStatus.unauthenticated;
  }

  bool _hasValidToken(String? token, DateTime? expiresAt) {
    if (token == null || token.isEmpty || expiresAt == null) {
      return false;
    }

    return expiresAt.isAfter(DateTime.now().toUtc());
  }
}
