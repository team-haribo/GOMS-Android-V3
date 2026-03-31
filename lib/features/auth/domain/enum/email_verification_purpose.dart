import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EmailVerificationPurpose {
  @JsonValue('SIGNUP')
  signup,

  @JsonValue('RESET_PASSWORD')
  resetPassword,
}
