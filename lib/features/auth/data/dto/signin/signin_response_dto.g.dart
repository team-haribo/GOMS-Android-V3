// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInResponseDto _$SignInResponseDtoFromJson(Map<String, dynamic> json) =>
    _SignInResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpiresIn:
          DateTime.parse(json['accessTokenExpiresIn'] as String),
      refreshTokenExpiresIn:
          DateTime.parse(json['refreshTokenExpiresIn'] as String),
    );

Map<String, dynamic> _$SignInResponseDtoToJson(_SignInResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpiresIn': instance.accessTokenExpiresIn.toIso8601String(),
      'refreshTokenExpiresIn': instance.refreshTokenExpiresIn.toIso8601String(),
    };
