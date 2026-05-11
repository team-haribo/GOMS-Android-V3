import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/password_reset/data/providers/password_reset_data_providers.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';
import 'package:goms/features/auth/password_reset/presentation/models/find_password_state.dart';

final findPasswordProvider =
    NotifierProvider<FindPasswordNotifier, FindPasswordState>(
  FindPasswordNotifier.new,
);

class FindPasswordNotifier extends Notifier<FindPasswordState> {
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

  void validateEmail(String email) {
    String? error;
    if (email.isNotEmpty && !_emailRegex.hasMatch(email)) {
      error = '잘못된 형식의 이메일입니다';
    }
    state = state.copyWith(email: email, emailError: error);
  }

  bool get isFormValid => state.email.isNotEmpty && state.emailError == null;

  Future<void> findPassword() async {
    if (!_emailRegex.hasMatch(state.email)) {
      state = state.copyWith(
        status: FindPasswordStatus.failure,
        emailError: '잘못된 형식의 이메일입니다',
      );
      return;
    }

    state = state.copyWith(status: FindPasswordStatus.loading);
    try {
      final normalizedEmail = normalizeSchoolEmail(state.email);
      await ref.read(passwordResetRemoteDataSourceProvider).sendEmailVerification(
            SendEmailVerificationRequestDto(
              email: normalizedEmail,
              purpose: EmailVerificationPurpose.passwordChange,
            ),
          );
      ref.read(authFlowProvider.notifier).startResetPassword(normalizedEmail);

      state = state.copyWith(status: FindPasswordStatus.success);
    } on DioException catch (e) {
      state = state.copyWith(
        status: FindPasswordStatus.failure,
        errorMessage: NetworkException.fromDioException(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: FindPasswordStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      status: FindPasswordStatus.initial,
      errorMessage: null,
    );
  }

  void reset() {
    ref.read(authFlowProvider.notifier).clear();
    emailController.clear();
    state = FindPasswordState.initial();
  }
}