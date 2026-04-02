import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';

part 'outing_student_response.freezed.dart';
part 'outing_student_response.g.dart';

@freezed
abstract class OutingStudentResponse with _$OutingStudentResponse {
  const factory OutingStudentResponse({
    required int memberId,
    required String name,
    required int grade,
    required String department,
    required DateTime outingAt,
  }) = _OutingStudentResponse;

  factory OutingStudentResponse.fromJson(Map<String, dynamic> json) =>
      _$OutingStudentResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension OutingStudentResponseX on OutingStudentResponse {
  OutingStudentEntity toEntity() {
    return OutingStudentEntity(
      memberId: memberId,
      name: name,
      grade: grade,
      department: department,
      outingAt: outingAt,
    );
  }
}
