import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';

part 'late_rank_student_response.g.dart';

@JsonSerializable(createToJson: false)
class LateRankStudentResponse {
  const LateRankStudentResponse({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.profileImageUrl,
    required this.comingAt,
  });

  factory LateRankStudentResponse.fromJson(Map<String, dynamic> json) =>
      _$LateRankStudentResponseFromJson(json);

  @JsonKey(defaultValue: 0)
  final int memberId;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: 0)
  final int grade;

  @JsonKey(defaultValue: '')
  final String department;

  @JsonKey(
    defaultValue: '',
    readValue: _readProfileImageUrl,
  )
  final String profileImageUrl;

  @JsonKey(fromJson: _comingAtFromJson)
  final DateTime comingAt;

  LateRankStudentEntity toEntity() {
    return LateRankStudentEntity(
      memberId: memberId,
      name: name,
      grade: grade,
      department: department,
      profileImageUrl: profileImageUrl,
      comingAt: comingAt,
    );
  }
}

Object? _readProfileImageUrl(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['profileUrl'];

DateTime _comingAtFromJson(String? value) =>
    DateTime.tryParse(value ?? '') ?? DateTime(0);
