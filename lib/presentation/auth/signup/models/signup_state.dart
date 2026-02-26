import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_setting/domain/enum/gender_enum.dart';
import 'package:project_setting/domain/enum/major_enum.dart';

part 'signup_state.freezed.dart';

/// 회원가입 상태
enum SignupStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  failure,
}

/// 회원가입 상태 모델
@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(SignupStatus.initial) SignupStatus status,
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    @Default('') String passwordConfirm,
    GenderEnum? gender,
    MajorEnum? major,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? passwordConfirmError,
    String? errorMessage,
  }) = _SignupState;

  /// 초기 상태
  factory SignupState.initial() => const SignupState();
}
