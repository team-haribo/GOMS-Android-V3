// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangePasswordRequestDto _$ChangePasswordRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _ChangePasswordRequestDto(
      email: json['email'] as String,
      verifiedToken: json['verifiedToken'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$ChangePasswordRequestDtoToJson(
        _ChangePasswordRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'verifiedToken': instance.verifiedToken,
      'newPassword': instance.newPassword,
    };
