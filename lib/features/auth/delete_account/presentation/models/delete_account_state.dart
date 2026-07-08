import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_state.freezed.dart';

/// 회원 탈퇴 상태
enum DeleteAccountStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  failure,
}

/// 회원 탈퇴 상태 모델
@freezed
abstract class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState({
    @Default(DeleteAccountStatus.initial) DeleteAccountStatus status,
    @Default('') String password,
    String? passwordError,
    String? errorMessage,
  }) = _DeleteAccountState;

  /// 초기 상태
  factory DeleteAccountState.initial() => const DeleteAccountState();
}
