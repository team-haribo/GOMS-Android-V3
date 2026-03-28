// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignUpRequestDto _$SignUpRequestDtoFromJson(Map<String, dynamic> json) =>
    _SignUpRequestDto(
      email: json['email'] as String,
      verifiedToken: json['verifiedToken'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      grade: (json['grade'] as num).toInt(),
      department: json['department'] as String,
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$SignUpRequestDtoToJson(_SignUpRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'verifiedToken': instance.verifiedToken,
      'password': instance.password,
      'name': instance.name,
      'grade': instance.grade,
      'department': instance.department,
      'gender': instance.gender,
    };
