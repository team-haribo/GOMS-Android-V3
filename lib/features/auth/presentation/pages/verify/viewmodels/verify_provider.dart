import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/auth/presentation/pages/verify/states/verify_state.dart';

final verifyProvider =
    NotifierProvider<VerifyNotifier, VerifyState>(VerifyNotifier.new);

class VerifyNotifier extends Notifier<VerifyState> {
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
      if (state.remainingSeconds <= 0) {
        timer.cancel();
        state = state.copyWith(
          isExpired: true,
          codeError: '인증시간이 만료되었습니다',
        );
      } else {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      }
    });
  }

  /// 포맷된 타이머 시간 (MM:SS)
  String get formattedTime {
    final minutes = (state.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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

  // ==================== Actions ====================

  /// 인증번호 확인
  Future<void> verify() async {
    if (!isFormValid) return;

    state = state.copyWith(status: VerifyStatus.loading);
    try {
      // TODO: 실제 인증 API 호출
      await Future.delayed(const Duration(seconds: 2));

      // 임시: 인증번호 검증 실패 예시
      /*state = state.copyWith(
        status: VerifyStatus.failure,
        codeError: '잘못된 인증번호입니다',
      ); */

      state = state.copyWith(status: VerifyStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: VerifyStatus.failure,
        errorMessage: '인증에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 인증번호 재발송
  Future<void> resend() async {
    _timer?.cancel();
    codeController.clear();
    state = VerifyState.initial();
    _startTimer();
    // TODO: 실제 재발송 API 호출
  }

  /// 상태 초기화
  void reset() {
    _timer?.cancel();
    codeController.clear();
    state = VerifyState.initial();
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


