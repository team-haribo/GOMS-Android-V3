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
  /// 포그라운드 복귀가 짧은 간격으로 반복될 때 프로필 조회가 몰리지 않도록
  /// 두는 최소 간격.
  static const roleSyncInterval = Duration(seconds: 30);

  DateTime? _lastRoleSyncAt;
  Future<void>? _roleSyncInFlight;

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
      return _loadSession();
    }

    final refreshToken = await TokenStorage.getRefreshToken();
    final refreshTokenExpiry = await TokenStorage.getRefreshTokenExpiry();
    if (!_hasValidToken(refreshToken, refreshTokenExpiry)) {
      await _clearSession();
      return false;
    }

    final outcome = await _reissue(refreshToken!);
    switch (outcome) {
      case _ReissueOutcome.success:
        return _loadSession();
      case _ReissueOutcome.rejected:
        // 리프레시 토큰이 서버에서 거부됨 → 세션은 이미 종료되었다.
        return false;
      case _ReissueOutcome.transient:
        // 재발급이 일시적으로 실패했을 뿐 리프레시 토큰은 유효하므로 토큰을 보존해
        // 다음 실행 때 다시 재발급을 시도할 수 있게 한다.
        _clearSessionState();
        return false;
    }
  }

  Future<bool> _loadSession() async {
    try {
      await _fetchCurrentMember();
      _lastRoleSyncAt = DateTime.now();
      _warmUpHomeData();
      state = AuthStatus.authenticated;
      return true;
    } catch (_) {
      _clearSessionState();
      return false;
    }
  }

  /// 앱을 켜 둔 동안 바뀐 권한을 반영한다. (이슈 #146)
  ///
  /// 앱을 켜 둔 채 권한이 부여·회수되면 스플래시의 [checkToken]이 다시 돌지 않아
  /// 이전 권한이 그대로 남는다. 서버는 토큰으로 사용자만 식별하고 권한은 DB에서
  /// 조회하므로, 재발급 없이 `/member/profile`만 다시 불러오면 최신 권한이 반영된다.
  ///
  /// 인증된 상태에서만 동작하고, 이미 진행 중이면 그 동기화를 기다린다.
  /// 포그라운드 복귀처럼 자동으로 호출될 때는 [roleSyncInterval] 안에 동기화했다면
  /// 건너뛰고, 당겨서 새로고침처럼 사용자가 직접 요청하면 [force]로 간격을 무시한다.
  Future<void> syncRole({bool force = false}) {
    if (state != AuthStatus.authenticated) {
      return Future.value();
    }

    final inFlight = _roleSyncInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final now = DateTime.now();
    final lastSyncedAt = _lastRoleSyncAt;
    if (!force &&
        lastSyncedAt != null &&
        now.difference(lastSyncedAt) < roleSyncInterval) {
      return Future.value();
    }
    _lastRoleSyncAt = now;

    final sync = _syncRole().whenComplete(() => _roleSyncInFlight = null);
    _roleSyncInFlight = sync;
    return sync;
  }

  Future<void> _syncRole() async {
    final previousRole = ref.read(currentMemberProvider).asData?.value?.role;
    await ref.read(currentMemberProvider.notifier).refreshProfile();
    final currentRole = ref.read(currentMemberProvider).asData?.value?.role;

    // 권한에 따라 서버가 내려주는 홈 데이터가 달라질 수 있어 다시 불러온다.
    if (state == AuthStatus.authenticated &&
        currentRole != null &&
        currentRole != previousRole) {
      _warmUpHomeData();
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
    _lastRoleSyncAt = null;
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
