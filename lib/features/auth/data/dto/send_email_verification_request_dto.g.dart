// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_email_verification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendEmailVerificationRequestDto _$SendEmailVerificationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _SendEmailVerificationRequestDto(
      email: json['email'] as String,
      purpose: $enumDecode(_$EmailVerificationPurposeEnumMap, json['purpose']),
    );

Map<String, dynamic> _$SendEmailVerificationRequestDtoToJson(
        _SendEmailVerificationRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'purpose': _$EmailVerificationPurposeEnumMap[instance.purpose]!,
    };

const _$EmailVerificationPurposeEnumMap = {
  EmailVerificationPurpose.signup: 'SIGNUP',
  EmailVerificationPurpose.resetPassword: 'RESET_PASSWORD',
};
