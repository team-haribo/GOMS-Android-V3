import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';

part 'confirm_email_verification_request_dto.freezed.dart';
part 'confirm_email_verification_request_dto.g.dart';

@freezed
abstract class ConfirmEmailVerificationRequestDto
    with _$ConfirmEmailVerificationRequestDto {
  const factory ConfirmEmailVerificationRequestDto({
    required String email,
    required String code,
    required EmailVerificationPurpose purpose,
  }) = _ConfirmEmailVerificationRequestDto;

  factory ConfirmEmailVerificationRequestDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ConfirmEmailVerificationRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
