// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'late_rank_student_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LateRankStudentResponse _$LateRankStudentResponseFromJson(
        Map<String, dynamic> json) =>
    LateRankStudentResponse(
      memberId: (json['memberId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      grade: (json['grade'] as num?)?.toInt() ?? 0,
      department: json['department'] as String? ?? '',
      profileImageUrl:
          _readProfileImageUrl(json, 'profileImageUrl') as String? ?? '',
      comingAt: _comingAtFromJson(json['comingAt'] as String?),
    );
