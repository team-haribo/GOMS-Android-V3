// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentMemberDto _$CurrentMemberDtoFromJson(Map<String, dynamic> json) =>
    CurrentMemberDto(
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: RoleEnum.fromServer(json['role'] as String?),
      grade: (json['grade'] as num?)?.toInt() ?? 0,
      department: $enumDecodeNullable(
              _$DepartmentTypeEnumMap, json['department'],
              unknownValue: DepartmentType.sw) ??
          DepartmentType.sw,
      gender: $enumDecodeNullable(_$GenderTypeEnumMap, json['gender'],
              unknownValue: GenderType.male) ??
          GenderType.male,
      status: $enumDecodeNullable(_$OutingStatusTypeEnumMap, json['status'],
              unknownValue: OutingStatusType.coming) ??
          OutingStatusType.coming,
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
    );

Map<String, dynamic> _$CurrentMemberDtoToJson(CurrentMemberDto instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'email': instance.email,
      'name': instance.name,
      'role': CurrentMemberDto._roleEnumToJson(instance.role),
      'grade': instance.grade,
      'department': _$DepartmentTypeEnumMap[instance.department]!,
      'gender': _$GenderTypeEnumMap[instance.gender]!,
      'status': _$OutingStatusTypeEnumMap[instance.status]!,
      'profileImageUrl': instance.profileImageUrl,
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

const _$OutingStatusTypeEnumMap = {
  OutingStatusType.outing: 'OUTING',
  OutingStatusType.coming: 'COMING',
  OutingStatusType.cannotOuting: 'CANNOT_OUTING',
};
