import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/delete_account/presentation/models/delete_account_state.dart';
import 'package:goms/features/auth/session/presentation/viewmodels/session_viewmodel.dart';
import 'package:goms/features/member/data/providers/member_providers.dart';

final deleteAccountProvider =
    NotifierProvider<DeleteAccountNotifier, DeleteAccountState>(
  DeleteAccountNotifier.new,
);

class DeleteAccountNotifier extends Notifier<DeleteAccountState> {
  // 비밀번호: 6자 이상, 영문/숫자/특수문자 포함
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

  void validatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_passwordRegex.hasMatch(password)) {
      error = '잘못된 형식의 비밀번호입니다';
    }
    state = state.copyWith(password: password, passwordError: error);
  }

  bool get isFormValid =>
      state.password.isNotEmpty && state.passwordError == null;

  Future<void> deleteAccount() async {
    if (!isFormValid) return;

    state = state.copyWith(status: DeleteAccountStatus.loading);

    try {
      await ref
          .read(memberRepositoryProvider)
          .withdrawMember(password: state.password);
      await TokenStorage.deleteAllTokens();
      ref.read(authProvider.notifier).setUnauthenticated();
      state = state.copyWith(status: DeleteAccountStatus.success);
    } on DioException catch (e) {
      state = state.copyWith(
        status: DeleteAccountStatus.failure,
        errorMessage: NetworkException.fromDioException(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: DeleteAccountStatus.failure,
        errorMessage: '회원 탈퇴에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      status: DeleteAccountStatus.initial,
      errorMessage: null,
    );
  }

  void reset() {
    passwordController.clear();
    state = DeleteAccountState.initial();
  }
}