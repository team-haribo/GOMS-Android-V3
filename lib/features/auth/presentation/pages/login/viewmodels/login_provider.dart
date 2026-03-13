import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/presentation/pages/login/models/login_state.dart';

/// 로그인 Provider
final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

/// 로그인 Notifier
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState.initial();
  }

  /// 이메일 유효성 검사
  String? _validateEmailLogic(String email) {
    if (email.isEmpty) {
      return '이메일을 입력해주세요';
    } else if (email.contains('@') && !email.endsWith('@gsm.hs.kr')) {
      return '잘못된 형식의 이메일입니다.';
    }
    return null;
  }

  /// 비밀번호 유효성 검사
  String? _validatePasswordLogic(String password) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  /// 이메일 유효성 검사
  void validateEmail(String email) {
    state = state.copyWith(emailError: _validateEmailLogic(email));
  }

  /// 비밀번호 유효성 검사
  void validatePassword(String password) {
    state = state.copyWith(passwordError: _validatePasswordLogic(password));
  }

  /// 로그인
  Future<void> login(String email, String password) async {
    // 유효성 검사
    final emailError = _validateEmailLogic(email);
    final passwordError = _validatePasswordLogic(password);

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    if (emailError != null || passwordError != null) return;

    state = LoginState.loading();

    try {
      // TODO: 실제 로그인 API 호출
      await Future.delayed(const Duration(seconds: 2));

      // TODO: API 응답에서 실제 토큰 받아오기
      // 임시: 더미 토큰
      const accessToken = 'dummy_access_token';
      const refreshToken = 'dummy_refresh_token';

      // 토큰 저장
      await TokenStorage.saveAccessToken(accessToken);
      await TokenStorage.saveRefreshToken(refreshToken);

      // 성공 처리
      state = LoginState.success(email);
    } catch (e) {
      state = LoginState.failure('로그인에 실패했습니다. 다시 시도해주세요.');
    }
  }

  /// 상태 초기화
  void reset() {
    state = LoginState.initial();
  }

  /// 에러 메시지 초기화
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(status: LoginStatus.initial, errorMessage: null);
    }
  }
}



