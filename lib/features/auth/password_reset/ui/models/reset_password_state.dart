import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

/// 비밀번호 재설정 상태
enum ResetPasswordStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  failure,
}

/// 비밀번호 재설정 상태 모델
@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(ResetPasswordStatus.initial) ResetPasswordStatus status,
    @Default('') String password,
    @Default('') String passwordConfirm,
    String? passwordError,
    String? passwordConfirmError,
    String? errorMessage,
  }) = _ResetPasswordState;

  /// 초기 상태
  factory ResetPasswordState.initial() => const ResetPasswordState();
}
