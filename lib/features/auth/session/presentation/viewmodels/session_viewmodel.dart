import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/auth/session_expiry_notifier.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/session/data/providers/session_data_providers.dart';
import 'package:goms/features/late/presentation/providers/late_rank_students_provider.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/presentation/providers/current_outing_students_provider.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  checking,
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(() {
  return AuthNotifier();
});

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
      final response = await ref.read(sessionRemoteDataSourceProvider).reissue(
            'Bearer ${refreshToken!.trim()}',
          );
      await TokenStorage.saveAccessToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveAccessTokenExpiry(response.accessTokenExpiresIn);
      await TokenStorage.saveRefreshTokenExpiry(response.refreshTokenExpiresIn);
      await _fetchCurrentMember();
      _warmUpHomeData();
      state = AuthStatus.authenticated;
      return true;
    } on DioException catch (error) {
      if (_isRefreshRejected(error)) {
        // 리프레시 토큰이 서버에서 실제로 거부된 경우에만 토큰을 삭제한다.
        await _clearSession();
      } else {
        // 타임아웃·연결 오류·서버 일시 오류 등에서는 토큰을 보존해
        // 다음 실행 때 다시 재발급을 시도할 수 있게 한다.
        _clearSessionState();
      }
      return false;
    } catch (_) {
      // 예기치 못한 오류에서도 토큰은 보존한다.
      _clearSessionState();
      return false;
    }
  }

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

  void setUnauthenticated() {
    _clearSessionState();
  }

  Future<void> logout() async {
    final refreshToken = await TokenStorage.getRefreshToken();

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await ref.read(sessionRemoteDataSourceProvider).signOut(
              'Bearer ${refreshToken.trim()}',
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

  bool _isRefreshRejected(DioException error) {
    final statusCode = error.response?.statusCode;
    return statusCode == 401 || statusCode == 403;
  }

  bool _hasValidToken(String? token, DateTime? expiresAt) {
    if (token == null || token.isEmpty || expiresAt == null) {
      return false;
    }

    return expiresAt.isAfter(DateTime.now().toUtc());
  }
}