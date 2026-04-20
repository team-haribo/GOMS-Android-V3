import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/features/auth/email_verification/data/providers/email_verification_data_providers.dart';
import 'package:goms/features/auth/verification/presentation/models/verify_state.dart';
import 'package:goms/features/auth/shared/presentation/providers/auth_flow_provider.dart';

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

  // ==================== Timer ====================

  /// 타이머 시작 (5분)
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

  /// 포맷된 타이머 시간 (MM:SS)
  String get formattedTime {
    final minutes = (state.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get resendButtonText => state.resendCooldownSeconds > 0
      ? '재발송 (${state.resendCooldownSeconds}s)'
      : '재발송';

  // ==================== Validation ====================

  /// 인증번호 입력 처리
  void setCode(String code) {
    state = state.copyWith(
      code: code,
      codeError: state.isExpired ? state.codeError : null,
    );
  }

  /// 폼 유효성 검사
  bool get isFormValid => state.code.isNotEmpty && !state.isExpired;

  bool get canResend => state.resendCooldownSeconds <= 0;

  // ==================== Actions ====================

  /// 인증번호 확인
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
          .read(emailVerificationRepositoryProvider)
          .confirmEmailVerification(
            email: authFlow.email,
            code: state.code,
            purpose: authFlow.purpose!,
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

  /// 인증번호 재발송
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
      await ref.read(emailVerificationRepositoryProvider).sendEmailVerification(
            email: authFlow.email,
            purpose: authFlow.purpose!,
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

  /// 상태 초기화
  void reset() {
    _timer?.cancel();
    codeController.clear();
    state = VerifyState.initial().copyWith(
      resendCooldownSeconds: _resendCooldownDurationSeconds,
      remainingSeconds: _verificationDurationSeconds,
    );
    _startTimer();
  }

  /// 상태 초기화 (success/failure 처리 후 호출)
  void resetStatus() {
    state = state.copyWith(
      status: VerifyStatus.initial,
      errorMessage: null,
    );
  }
}
