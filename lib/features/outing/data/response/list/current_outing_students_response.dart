import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/data/response/outing_student_response.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';

part 'current_outing_students_response.freezed.dart';
part 'current_outing_students_response.g.dart';

@freezed
abstract class CurrentOutingStudentsResponse
    with _$CurrentOutingStudentsResponse {
  const factory CurrentOutingStudentsResponse({
    required List<OutingStudentResponse> students,
  }) = _CurrentOutingStudentsResponse;

  factory CurrentOutingStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentOutingStudentsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension CurrentOutingStudentsResponseX on CurrentOutingStudentsResponse {
  List<OutingStudentEntity> toEntity() {
    return students.map((student) => student.toEntity()).toList();
  }
}
