import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_state.freezed.dart';

/// 인증 상태
enum VerifyStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  failure,
}

/// 인증번호 확인 상태 모델
@freezed
abstract class VerifyState with _$VerifyState {
  const factory VerifyState({
    @Default(VerifyStatus.initial) VerifyStatus status,
    @Default('') String code,
    @Default(300) int remainingSeconds,
    @Default(60) int resendCooldownSeconds,
    @Default(false) bool isExpired,
    String? codeError,
    String? errorMessage,
  }) = _VerifyState;

  factory VerifyState.initial() => const VerifyState();
}
