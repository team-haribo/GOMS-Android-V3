import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EmailVerificationPurpose {
  @JsonValue('SIGNUP')
  signup,

  @JsonValue('PASSWORD_CHANGE')
  passwordChange,
}
