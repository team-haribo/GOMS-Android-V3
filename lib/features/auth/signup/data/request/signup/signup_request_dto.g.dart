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
      department: $enumDecode(_$DepartmentTypeEnumMap, json['department']),
      gender: $enumDecode(_$GenderTypeEnumMap, json['gender']),
    );

Map<String, dynamic> _$SignUpRequestDtoToJson(_SignUpRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'verifiedToken': instance.verifiedToken,
      'password': instance.password,
      'name': instance.name,
      'grade': instance.grade,
      'department': _$DepartmentTypeEnumMap[instance.department]!,
      'gender': _$GenderTypeEnumMap[instance.gender]!,
    };

const _$DepartmentTypeEnumMap = {
  DepartmentType.sw: 'SW',
  DepartmentType.iot: 'IOT',
  DepartmentType.ai: 'AI',
};

const _$GenderTypeEnumMap = {
  GenderType.male: 'MALE',
  GenderType.female: 'FEMALE',
};
