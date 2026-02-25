import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/utils/token_storage.dart';


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
    final hasToken = accessToken != null && accessToken.isNotEmpty;

    state = hasToken ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    return hasToken;
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
}
