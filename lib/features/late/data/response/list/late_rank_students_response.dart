import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/late/data/response/late_rank_student_response.dart';
import 'package:goms/features/late/ui/models/late_rank_student_model.dart';

part 'late_rank_students_response.g.dart';

@JsonSerializable(createToJson: false)
class LateRankStudentsResponse {
  const LateRankStudentsResponse({
    required this.students,
  });

  factory LateRankStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$LateRankStudentsResponseFromJson(json);

  @JsonKey(
    defaultValue: <LateRankStudentResponse>[],
    fromJson: _studentsFromJson,
  )
  final List<LateRankStudentResponse> students;

  List<LateRankStudentModel> toModel() {
    return students.map((student) => student.toModel()).toList();
  }
}

List<LateRankStudentResponse> _studentsFromJson(List<dynamic>? values) =>
    (values ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(LateRankStudentResponse.fromJson)
        .toList(growable: false);
