import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/auth/session_expiry_notifier.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/session/data/providers/session_data_providers.dart';
import 'package:goms/features/late/ui/providers/late_rank_students_provider.dart';
import 'package:goms/features/member/ui/providers/current_member_provider.dart';
import 'package:goms/features/outing/ui/providers/current_outing_students_provider.dart';
import 'package:goms/features/outing/ui/providers/my_outing_status_provider.dart';

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
  AuthStatus build() {
    Future<void> handleSessionExpiry() async {
      _clearSessionState();
    }

    SessionExpiryNotifier.register(handleSessionExpiry);
    ref.onDispose(() {
      SessionExpiryNotifier.unregister(handleSessionExpiry);
    });

    return AuthStatus.checking;
  }

  /// 토큰 유효성 확인
  Future<bool> checkToken() async {
    state = AuthStatus.checking;
    final accessToken = await TokenStorage.getAccessToken();
    final accessTokenExpiry = await TokenStorage.getAccessTokenExpiry();

    if (_hasValidToken(accessToken, accessTokenExpiry)) {
      try {
        await _fetchCurrentMember();
        _warmUpHomeData();
        state = AuthStatus.authenticated;
        return true;
      } catch (_) {
        _clearSessionState();
        return false;
      }
    }

    final refreshToken = await TokenStorage.getRefreshToken();
    final refreshTokenExpiry = await TokenStorage.getRefreshTokenExpiry();

    if (!_hasValidToken(refreshToken, refreshTokenExpiry)) {
      await _clearSession();
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
      _warmUpHomeData();
      state = AuthStatus.authenticated;
      return true;
    } on DioException catch (_) {
      await _clearSession();
      return false;
    } catch (_) {
      await _clearSession();
      return false;
    }
  }

  /// 로그인 완료 처리
  Future<void> setAuthenticated() async {
    try {
      await _fetchCurrentMember();
      _warmUpHomeData();
      state = AuthStatus.authenticated;
    } catch (_) {
      await _clearSession();
      rethrow;
    }
  }

  /// 인증 해제 처리
  void setUnauthenticated() {
    _clearSessionState();
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
      await _clearSession();
    }
  }

  Future<void> _clearSession() async {
    await TokenStorage.deleteAllTokens();
    _clearSessionState();
  }

  void _clearSessionState() {
    ref.read(currentMemberProvider.notifier).clear();
    ref.invalidate(currentOutingStudentsProvider);
    ref.invalidate(lateRankStudentsProvider);
    ref.invalidate(myOutingStatusProvider);
    state = AuthStatus.unauthenticated;
  }

  Future<void> _fetchCurrentMember() async {
    await ref.read(currentMemberProvider.notifier).fetch();
  }

  void _warmUpHomeData() {
    unawaited(
      ref.read(myOutingStatusProvider.notifier).reload().catchError((_) {}),
    );
    unawaited(
      ref
          .read(currentOutingStudentsProvider.notifier)
          .reload()
          .catchError((_) {}),
    );
    unawaited(
      ref.read(lateRankStudentsProvider.notifier).reload().catchError((_) {}),
    );
  }

  bool _hasValidToken(String? token, DateTime? expiresAt) {
    if (token == null || token.isEmpty || expiresAt == null) {
      return false;
    }

    return expiresAt.isAfter(DateTime.now().toUtc());
  }
}
