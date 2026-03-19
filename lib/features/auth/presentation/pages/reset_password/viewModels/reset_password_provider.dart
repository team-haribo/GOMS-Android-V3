import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/auth/presentation/pages/reset_password/models/reset_password_state.dart';

/// 비밀번호 재설정 Provider
final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  ResetPasswordNotifier.new,
);

/// 비밀번호 재설정 Notifier
class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  /// 비밀번호: 6자 이상, 대/소문자, 숫자, 특수문자 포함
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&?~])[a-zA-Z\d!@#$%^&?~]{6,}$',
  );

  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  ResetPasswordState build() {
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();

    ref.onDispose(() {
      passwordController.dispose();
      passwordConfirmController.dispose();
    });

    return ResetPasswordState.initial();
  }

  // ==================== 유효성 검사 ====================

  /// 비밀번호 유효성 검사
  void validatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_passwordRegex.hasMatch(password)) {
      error = '잘못된 형식의 비밀번호입니다';
    }
    state = state.copyWith(password: password, passwordError: error);

    // 비밀번호 확인 필드 재검증
    if (state.passwordConfirm.isNotEmpty) {
      _revalidatePasswordConfirm();
    }
  }

  /// 비밀번호 확인 유효성 검사
  void validatePasswordConfirm(String passwordConfirm) {
    String? error;
    if (passwordConfirm.isNotEmpty && passwordConfirm != state.password) {
      error = '비밀번호가 일치하지 않습니다';
    }
    state = state.copyWith(
      passwordConfirm: passwordConfirm,
      passwordConfirmError: error,
    );
  }

  /// 비밀번호 변경 시 확인 필드 재검증
  void _revalidatePasswordConfirm() {
    final error =
        state.passwordConfirm != state.password ? '비밀번호가 일치하지 않습니다' : null;
    state = state.copyWith(passwordConfirmError: error);
  }

  /// 폼 유효성 검사
  bool get isFormValid =>
      state.password.isNotEmpty &&
      state.passwordConfirm.isNotEmpty &&
      state.passwordError == null &&
      state.passwordConfirmError == null &&
      _passwordRegex.hasMatch(state.password) &&
      state.password == state.passwordConfirm;

  // ==================== Actions ====================

  /// 비밀번호 재설정 제출
  Future<void> resetPassword() async {
    if (!isFormValid) return;

    state = state.copyWith(status: ResetPasswordStatus.loading);
    try {
      // TODO: 실제 비밀번호 재설정 API 호출
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(status: ResetPasswordStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: '비밀번호 재설정에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(
      status: ResetPasswordStatus.initial,
      errorMessage: null,
    );
  }

  /// 상태 초기화
  void reset() {
    passwordController.clear();
    passwordConfirmController.clear();
    state = ResetPasswordState.initial();
  }
}




