import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/auth/domain/enum/email_verification_purpose.dart';

part 'send_email_verification_request_dto.freezed.dart';
part 'send_email_verification_request_dto.g.dart';

@freezed
abstract class SendEmailVerificationRequestDto
    with _$SendEmailVerificationRequestDto {
  const factory SendEmailVerificationRequestDto({
    required String email,
    required EmailVerificationPurpose purpose,
  }) = _SendEmailVerificationRequestDto;

  factory SendEmailVerificationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SendEmailVerificationRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
