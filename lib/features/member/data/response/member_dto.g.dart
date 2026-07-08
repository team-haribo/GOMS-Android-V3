// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberDto _$MemberDtoFromJson(Map<String, dynamic> json) => MemberDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      studentNumber: json['studentNumber'] as String? ?? '',
      role: json['role'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
    );

Map<String, dynamic> _$MemberDtoToJson(MemberDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'studentNumber': instance.studentNumber,
      'role': instance.role,
      'profileImageUrl': instance.profileImageUrl,
    };
