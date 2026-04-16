import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_password_state.freezed.dart';

enum FindPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
abstract class FindPasswordState with _$FindPasswordState {
  const factory FindPasswordState({
    @Default(FindPasswordStatus.initial) FindPasswordStatus status,
    @Default('') String email,
    String? emailError,
    String? errorMessage,
  }) = _FindPasswordState;

  factory FindPasswordState.initial() => const FindPasswordState();
}
