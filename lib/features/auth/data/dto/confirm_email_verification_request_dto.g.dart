// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_email_verification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConfirmEmailVerificationRequestDto
    _$ConfirmEmailVerificationRequestDtoFromJson(Map<String, dynamic> json) =>
        _ConfirmEmailVerificationRequestDto(
          email: json['email'] as String,
          code: json['code'] as String,
          purpose:
              $enumDecode(_$EmailVerificationPurposeEnumMap, json['purpose']),
        );

Map<String, dynamic> _$ConfirmEmailVerificationRequestDtoToJson(
        _ConfirmEmailVerificationRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
      'purpose': _$EmailVerificationPurposeEnumMap[instance.purpose]!,
    };

const _$EmailVerificationPurposeEnumMap = {
  EmailVerificationPurpose.signup: 'SIGNUP',
  EmailVerificationPurpose.resetPassword: 'RESET_PASSWORD',
};
