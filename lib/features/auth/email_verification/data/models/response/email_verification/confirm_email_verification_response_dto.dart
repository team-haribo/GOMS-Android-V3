import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_email_verification_response_dto.freezed.dart';
part 'confirm_email_verification_response_dto.g.dart';

@freezed
abstract class ConfirmEmailVerificationResponseDto
    with _$ConfirmEmailVerificationResponseDto {
  const factory ConfirmEmailVerificationResponseDto({
    required String verifiedToken,
  }) = _ConfirmEmailVerificationResponseDto;

  factory ConfirmEmailVerificationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ConfirmEmailVerificationResponseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
