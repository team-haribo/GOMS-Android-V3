import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/auth/presentation/pages/reset_password/models/find_password_state.dart';

/// 비밀번호 찾기 Provider
final findPasswordProvider =
    NotifierProvider<FindPasswordNotifier, FindPasswordState>(
  FindPasswordNotifier.new,
);

/// 비밀번호 찾기 Notifier
class FindPasswordNotifier extends Notifier<FindPasswordState> {
  /// 이메일 로컬파트 유효성: s + 숫자 형식
  static final _emailRegex = RegExp(r'^s\d+$');

  late final TextEditingController emailController;

  @override
  FindPasswordState build() {
    emailController = TextEditingController();
    ref.onDispose(() {
      emailController.dispose();
    });
    return FindPasswordState.initial();
  }

  // ==================== 유효성 검사 ====================

  /// 이메일 입력 처리 및 유효성 검사
  void validateEmail(String email) {
    String? error;
    if (email.isNotEmpty && !_emailRegex.hasMatch(email)) {
      error = '잘못된 형식의 이메일입니다';
    }
    state = state.copyWith(email: email, emailError: error);
  }

  /// 폼 유효성 검사
  bool get isFormValid => state.email.isNotEmpty && state.emailError == null;

  // ==================== Actions ====================

  /// 인증번호 발송
  Future<void> findPassword() async {
    // 이메일 최종 검증
    if (!_emailRegex.hasMatch(state.email)) {
      state = state.copyWith(
        status: FindPasswordStatus.failure,
        emailError: '잘못된 형식의 이메일입니다',
      );
      return;
    }

    state = state.copyWith(status: FindPasswordStatus.loading);
    try {
      // TODO: 실제 인증번호 발송 API 호출
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(status: FindPasswordStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: FindPasswordStatus.failure,
        errorMessage: '알 수 없는 오류가 발생했습니다',
      );
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(
      status: FindPasswordStatus.initial,
      errorMessage: null,
    );
  }

  /// 상태 초기화
  void reset() {
    emailController.clear();
    state = FindPasswordState.initial();
  }
}




