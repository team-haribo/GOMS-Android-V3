import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/auth/access_denied_notifier.dart';
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
  Future<bool>? _roleSyncInFlight;

  /// 로그아웃·세션 만료마다 올라가는 세션 번호. 이전 세션에서 시작한 권한 동기화가
  /// 새 세션에 결과를 반영하거나 실패를 알리지 않도록 구분하는 데 쓴다.
  int _sessionGeneration = 0;

  @override
  AuthStatus build() {
    Future<void> handleSessionExpiry() async {
      _clearSessionState();
    }

    // 관리자 API가 최신 토큰으로도 403이면 권한이 회수된 것이므로 바로 다시
    // 조회한다. (이슈 #150) 자동 동기화 간격과 무관하게 반영해야 하므로 force로 요청한다.
    void handleAccessDenied() {
      unawaited(syncRole(force: true));
    }

    SessionExpiryNotifier.register(handleSessionExpiry);
    AccessDeniedNotifier.register(handleAccessDenied);
    ref.onDispose(() {
      SessionExpiryNotifier.unregister(handleSessionExpiry);
      AccessDeniedNotifier.unregister(handleAccessDenied);
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
  ///
  /// 조회에 실패했을 때만 false를 돌려준다. 건너뛴 경우나 인증되지 않은 상태는
  /// 알릴 실패가 없으므로 true다.
  Future<bool> syncRole({bool force = false}) {
    if (state != AuthStatus.authenticated) {
      return Future.value(true);
    }

    // force여도 진행 중인 조회가 있으면 새로 보내지 않고 그 결과를 기다린다.
    // 방금 보낸 요청이라 결과가 같고, 같은 응답을 두 번 받을 이유가 없다.
    final inFlight = _roleSyncInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final lastSyncedAt = _lastRoleSyncAt;
    if (!force &&
        lastSyncedAt != null &&
        DateTime.now().difference(lastSyncedAt) < roleSyncInterval) {
      return Future.value(true);
    }

    late final Future<bool> sync;
    sync = _syncRole(_sessionGeneration).whenComplete(() {
      // 그 사이 로그아웃으로 비워졌거나 새 동기화로 바뀌었다면 건드리지 않는다.
      if (identical(_roleSyncInFlight, sync)) {
        _roleSyncInFlight = null;
      }
    });
    _roleSyncInFlight = sync;
    return sync;
  }

  Future<bool> _syncRole(int generation) async {
    final previousRole = ref.read(currentMemberProvider).asData?.value?.role;
    final refreshed =
        await ref.read(currentMemberProvider.notifier).refreshProfile();

    // await 도중 로그아웃됐다면 이전 세션의 결과다. 새 세션에 반영하지 않고,
    // 알릴 실패도 아니다.
    if (generation != _sessionGeneration) {
      return true;
    }
    // 조회에 성공했을 때만 시각을 남긴다. 실패하면 이전 시각도 지워, 다음 복귀 때
    // 최소 간격과 관계없이 바로 다시 시도한다.
    _lastRoleSyncAt = refreshed ? DateTime.now() : null;
    final currentRole = ref.read(currentMemberProvider).asData?.value?.role;

    // 권한에 따라 서버가 내려주는 홈 데이터가 달라질 수 있어 다시 불러온다.
    if (state == AuthStatus.authenticated &&
        currentRole != null &&
        currentRole != previousRole) {
      _warmUpHomeData();
    }

    return refreshed;
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
      _lastRoleSyncAt = DateTime.now();
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
    _sessionGeneration++;
    _lastRoleSyncAt = null;
    _roleSyncInFlight = null;
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
