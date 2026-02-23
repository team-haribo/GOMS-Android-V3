import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// 로그인 상태
enum LoginStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  failure,
}

/// 로그인 상태 모델
@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.initial) LoginStatus status,
    String? errorMessage,
    String? email,
    String? emailError,
    String? passwordError,
  }) = _LoginState;

  /// 초기 상태
  factory LoginState.initial() => const LoginState();

  /// 로딩 상태
  factory LoginState.loading() => const LoginState(status: LoginStatus.loading);

  /// 성공 상태
  factory LoginState.success(String email) =>
      LoginState(status: LoginStatus.success, email: email);

  /// 실패 상태
  factory LoginState.failure(String errorMessage) =>
      LoginState(status: LoginStatus.failure, errorMessage: errorMessage);
}
