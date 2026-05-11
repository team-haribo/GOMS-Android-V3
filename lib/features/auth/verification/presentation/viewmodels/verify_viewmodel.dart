import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/confirm_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/email_verification/data/providers/email_verification_data_providers.dart';
import 'package:goms/features/auth/verification/presentation/states/verify_state.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';

final verifyProvider =
    NotifierProvider<VerifyNotifier, VerifyState>(VerifyNotifier.new);

class VerifyNotifier extends Notifier<VerifyState> {
  static const int _verificationDurationSeconds = 300;
  static const int _resendCooldownDurationSeconds = 60;

  late final TextEditingController codeController;
  Timer? _timer;

  @override
  VerifyState build() {
    codeController = TextEditingController();
    ref.onDispose(() {
      _timer?.cancel();
      codeController.dispose();
    });
    _startTimer();
    return VerifyState.initial();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextRemainingSeconds = state.remainingSeconds - 1;
      final nextResendCooldownSeconds =
          state.resendCooldownSeconds > 0 ? state.resendCooldownSeconds - 1 : 0;

      if (nextRemainingSeconds <= 0) {
        timer.cancel();
        state = state.copyWith(
          remainingSeconds: 0,
          resendCooldownSeconds: nextResendCooldownSeconds,
          isExpired: true,
          codeError: '인증시간이 만료되었습니다.',
        );
        return;
      }

      state = state.copyWith(
        remainingSeconds: nextRemainingSeconds,
        resendCooldownSeconds: nextResendCooldownSeconds,
      );
    });
  }

  String get formattedTime {
    final minutes = (state.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get resendButtonText => state.resendCooldownSeconds > 0
      ? '재발송 (${state.resendCooldownSeconds}s)'
      : '재발송';

  void setCode(String code) {
    state = state.copyWith(
      code: code,
      codeError: state.isExpired ? state.codeError : null,
    );
  }

  bool get isFormValid => state.code.isNotEmpty && !state.isExpired;

  bool get canResend => state.resendCooldownSeconds <= 0;

  Future<void> verify() async {
    if (!isFormValid) return;

    final authFlow = ref.read(authFlowProvider);
    if (authFlow.email.isEmpty || authFlow.purpose == null) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        errorMessage: '인증 정보를 찾을 수 없습니다. 다시 시도해주세요.',
      );
      return;
    }

    state = state.copyWith(status: VerifyStatus.loading);
    try {
      final response = await ref
          .read(emailVerificationRemoteDataSourceProvider)
          .confirmEmailVerification(
            ConfirmEmailVerificationRequestDto(
              email: authFlow.email,
              code: state.code,
              purpose: authFlow.purpose!,
            ),
          );
      ref
          .read(authFlowProvider.notifier)
          .setVerifiedToken(response.verifiedToken);
      state = state.copyWith(status: VerifyStatus.success);
    } on DioException catch (e) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        codeError: NetworkException.fromDioException(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resend() async {
    if (!canResend) return;

    final authFlow = ref.read(authFlowProvider);
    if (authFlow.email.isEmpty || authFlow.purpose == null) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        errorMessage: '재발송할 인증 정보를 찾을 수 없습니다.',
      );
      return;
    }

    _timer?.cancel();
    codeController.clear();
    state = VerifyState.initial().copyWith(
      resendCooldownSeconds: _resendCooldownDurationSeconds,
      remainingSeconds: _verificationDurationSeconds,
    );
    _startTimer();

    try {
      ref.read(authFlowProvider.notifier).clearVerifiedToken();
      await ref
          .read(emailVerificationRemoteDataSourceProvider)
          .sendEmailVerification(
            SendEmailVerificationRequestDto(
              email: authFlow.email,
              purpose: authFlow.purpose!,
            ),
          );
    } on DioException catch (e) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        errorMessage: NetworkException.fromDioException(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    _timer?.cancel();
    codeController.clear();
    state = VerifyState.initial().copyWith(
      resendCooldownSeconds: _resendCooldownDurationSeconds,
      remainingSeconds: _verificationDurationSeconds,
    );
    _startTimer();
  }

  void clear() {
    _timer?.cancel();
    codeController.clear();
    state = VerifyState.initial();
  }

  void resetStatus() {
    state = state.copyWith(
      status: VerifyStatus.initial,
      errorMessage: null,
    );
  }
}
