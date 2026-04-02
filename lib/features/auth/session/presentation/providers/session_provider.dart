import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/session/data/providers/session_data_providers.dart';
import 'package:goms/features/member/presentation/viewmodels/current_member_provider.dart';

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
      try {
        await _fetchCurrentMember();
        state = AuthStatus.authenticated;
        return true;
      } catch (_) {
        ref.read(currentMemberProvider.notifier).clear();
        state = AuthStatus.unauthenticated;
        return false;
      }
    }

    final refreshToken = await TokenStorage.getRefreshToken();
    final refreshTokenExpiry = await TokenStorage.getRefreshTokenExpiry();

    if (!_hasValidToken(refreshToken, refreshTokenExpiry)) {
      await TokenStorage.deleteAllTokens();
      state = AuthStatus.unauthenticated;
      return false;
    }

    try {
      final response = await ref.read(sessionRepositoryProvider).reissue(
            refreshToken: refreshToken!,
          );
      await TokenStorage.saveAccessToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveAccessTokenExpiry(response.accessTokenExpiresIn);
      await TokenStorage.saveRefreshTokenExpiry(response.refreshTokenExpiresIn);
      await _fetchCurrentMember();
      state = AuthStatus.authenticated;
      return true;
    } on DioException catch (_) {
      await TokenStorage.deleteAllTokens();
      ref.read(currentMemberProvider.notifier).clear();
      state = AuthStatus.unauthenticated;
      return false;
    } catch (_) {
      await TokenStorage.deleteAllTokens();
      ref.read(currentMemberProvider.notifier).clear();
      state = AuthStatus.unauthenticated;
      return false;
    }
  }

  /// 로그인 완료 처리
  Future<void> setAuthenticated() async {
    try {
      await _fetchCurrentMember();
      state = AuthStatus.authenticated;
    } catch (_) {
      await TokenStorage.deleteAllTokens();
      ref.read(currentMemberProvider.notifier).clear();
      state = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  /// 인증 해제 처리
  void setUnauthenticated() {
    ref.read(currentMemberProvider.notifier).clear();
    state = AuthStatus.unauthenticated;
  }

  /// 로그아웃
  Future<void> logout() async {
    final refreshToken = await TokenStorage.getRefreshToken();

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await ref.read(sessionRepositoryProvider).signOut(
              refreshToken: refreshToken,
            );
      }
    } on DioException catch (_) {
      // 서버 로그아웃이 실패해도 로컬 세션은 종료한다.
    } catch (_) {
      // 로컬 세션 종료는 항상 보장한다.
    } finally {
      await TokenStorage.deleteAllTokens();
      ref.read(currentMemberProvider.notifier).clear();
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> _fetchCurrentMember() async {
    await ref.read(currentMemberProvider.notifier).fetch();
  }

  bool _hasValidToken(String? token, DateTime? expiresAt) {
    if (token == null || token.isEmpty || expiresAt == null) {
      return false;
    }

    return expiresAt.isAfter(DateTime.now().toUtc());
  }
}
