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

/// 재발급(reissue) 시도 결과.
/// - [success]: 새 토큰 저장 완료
/// - [rejected]: 리프레시 토큰이 서버에서 거부됨(401/403) → 세션 종료
/// - [transient]: 일시 장애(타임아웃·연결·5xx 등) → 토큰 보존
enum _ReissueOutcome { success, rejected, transient }

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

    final refreshToken = await TokenStorage.getRefreshToken();
    final refreshTokenExpiry = await TokenStorage.getRefreshTokenExpiry();
    final hasValidRefresh = _hasValidToken(refreshToken, refreshTokenExpiry);

    // 리프레시 토큰이 유효하면 access token의 만료 여부와 관계없이 항상 재발급을
    // 먼저 시도한다. 디스코드 권한 동기화 후에도 기존 access token의 role claim이
    // 남아 이전 권한(학생회 등)이 계속 보이던 문제를 막기 위함이다. 재발급으로
    // role claim을 최신화한 뒤 멤버 정보를 다시 불러온다. (이슈 #123)
    if (hasValidRefresh) {
      final outcome = await _reissue(refreshToken!);
      if (outcome == _ReissueOutcome.success) {
        return _loadSession();
      }
      if (outcome == _ReissueOutcome.rejected) {
        // 리프레시 토큰이 서버에서 거부됨 → 세션은 이미 종료되었다.
        return false;
      }
      // 일시 장애: 아직 유효한 access token이 있으면 그걸로 폴백한다.
    }

    final accessToken = await TokenStorage.getAccessToken();
    final accessTokenExpiry = await TokenStorage.getAccessTokenExpiry();
    if (_hasValidToken(accessToken, accessTokenExpiry)) {
      return _loadSession();
    }

    if (hasValidRefresh) {
      // 재발급이 일시적으로 실패했을 뿐 리프레시 토큰은 유효하므로 토큰을 보존해
      // 다음 실행 때 다시 재발급을 시도할 수 있게 한다.
      _clearSessionState();
    } else {
      await _clearSession();
    }
    return false;
  }

  Future<bool> _loadSession() async {
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

  Future<_ReissueOutcome> _reissue(String refreshToken) async {
    try {
      final response = await ref.read(sessionRemoteDataSourceProvider).reissue(
            'Bearer ${refreshToken.trim()}',
          );
      await TokenStorage.saveAccessToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveAccessTokenExpiry(response.accessTokenExpiresIn);
      await TokenStorage.saveRefreshTokenExpiry(response.refreshTokenExpiresIn);
      return _ReissueOutcome.success;
    } on DioException catch (error) {
      if (_isRefreshRejected(error)) {
        // 리프레시 토큰이 서버에서 실제로 거부된 경우에만 토큰을 삭제한다.
        await _clearSession();
        return _ReissueOutcome.rejected;
      }
      // 타임아웃·연결 오류·서버 일시 오류 등에서는 토큰을 보존한다.
      return _ReissueOutcome.transient;
    } catch (_) {
      // 예기치 못한 오류에서도 토큰은 보존한다.
      return _ReissueOutcome.transient;
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