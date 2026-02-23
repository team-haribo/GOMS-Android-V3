import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/presentation/auth/login/state/login_state.dart';

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
  void validateEmail(String email) {
    if (email.isEmpty) {
      state = state.copyWith(emailError: '이메일을 입력해주세요');
    } else if (email.contains('@') && !email.endsWith('@gsm.hs.kr')) {
      state = state.copyWith(emailError: '잘못된 형식의 이메일입니다.');
    } else {
      state = state.copyWith(emailError: null);
    }
  }

  /// 비밀번호 유효성 검사
  void validatePassword(String password) {
    if (password.isEmpty) {
      state = state.copyWith(passwordError: '비밀번호를 입력해주세요');
    } else {
      state = state.copyWith(passwordError: null);
    }
  }

  /// 로그인
  Future<void> login(String email, String password) async {
    // 유효성 검사
    state = state.copyWith(emailError: null, passwordError: null);

    bool hasError = false;
    if (email.isEmpty) {
      state = state.copyWith(emailError: '이메일을 입력해주세요');
      hasError = true;
    } else if (email.contains('@') && !email.endsWith('@gsm.hs.kr')) {
      state = state.copyWith(emailError: '잘못된 형식의 이메일입니다.');
      hasError = true;
    }
    if (password.isEmpty) {
      state = state.copyWith(passwordError: '비밀번호를 입력해주세요');
      hasError = true;
    }

    if (hasError) return;

    state = LoginState.loading();

    try {
      // TODO: 실제 로그인 API 호출
      await Future.delayed(const Duration(seconds: 2));

      // 임시: 실패 응답 시뮬레이션 (나중에 API 연동 시 제거)
      // 실제로는 API 응답에 따라 처리
      const bool isEmailValid = false; // API 응답에서 판단

      if (!isEmailValid) {
        state = state.copyWith(
          status: LoginStatus.initial,
          emailError: '잘못된 형식의 이메일입니다.',
        );
        return;
      }
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
