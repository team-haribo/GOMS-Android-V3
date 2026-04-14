import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';

part 'student_council_student_entity.freezed.dart';

@freezed
abstract class StudentCouncilStudentEntity with _$StudentCouncilStudentEntity {
  const factory StudentCouncilStudentEntity({
    required int memberId,
    required String name,
    required int grade,
    required String department,
    required StudentRole studentRole,
    @Default('') String profileImageUrl,
    @Default('') String role,
    @Default('') String status,
  }) = _StudentCouncilStudentEntity;
}
