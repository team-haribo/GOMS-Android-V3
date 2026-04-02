import 'package:goms/features/late/data/response/late_rank_student_response.dart';
import 'package:goms/features/late/domain/entities/late_rank_student_entity.dart';

class LateRankStudentsResponse {
  const LateRankStudentsResponse({
    required this.students,
  });

  factory LateRankStudentsResponse.fromJson(Map<String, dynamic> json) {
    final students = (json['students'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(LateRankStudentResponse.fromJson)
        .toList();

    return LateRankStudentsResponse(students: students);
  }

  final List<LateRankStudentResponse> students;

  List<LateRankStudentEntity> toEntity() {
    return students.map((student) => student.toEntity()).toList();
  }
}
