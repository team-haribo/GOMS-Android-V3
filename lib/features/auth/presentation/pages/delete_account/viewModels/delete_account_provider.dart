import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/auth/presentation/pages/delete_account/models/delete_account_state.dart';

/// 회원 탈퇴 Provider
final deleteAccountProvider =
    NotifierProvider<DeleteAccountNotifier, DeleteAccountState>(
  DeleteAccountNotifier.new,
);

/// 회원 탈퇴 Notifier
class DeleteAccountNotifier extends Notifier<DeleteAccountState> {
  /// 비밀번호: 6자 이상, 영문/숫자/특수문자 포함
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&?~])[a-zA-Z\d!@#$%^&?~]{6,}$',
  );

  late final TextEditingController passwordController;

  @override
  DeleteAccountState build() {
    passwordController = TextEditingController();

    ref.onDispose(() {
      passwordController.dispose();
    });

    return DeleteAccountState.initial();
  }

  // ==================== 유효성 검사 ====================

  /// 비밀번호 유효성 검사
  void validatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_passwordRegex.hasMatch(password)) {
      error = '잘못된 형식의 비밀번호입니다';
    }
    state = state.copyWith(password: password, passwordError: error);
  }

  /// 폼 유효성 여부
  bool get isFormValid =>
      state.password.isNotEmpty && state.passwordError == null;

  // ==================== Actions ====================

  /// 회원 탈퇴 제출
  Future<void> deleteAccount() async {
    if (!isFormValid) return;

    state = state.copyWith(status: DeleteAccountStatus.loading);

    try {
      // TODO: 실제 회원 탈퇴 API 호출
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(status: DeleteAccountStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: DeleteAccountStatus.failure,
        errorMessage: '회원 탈퇴에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(
      status: DeleteAccountStatus.initial,
      errorMessage: null,
    );
  }

  /// 상태 초기화
  void reset() {
    passwordController.clear();
    state = DeleteAccountState.initial();
  }
}


