// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInRequestDto _$SignInRequestDtoFromJson(Map<String, dynamic> json) =>
    _SignInRequestDto(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignInRequestDtoToJson(_SignInRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
