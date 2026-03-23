import 'package:goms/domain/enum/student_role_enum.dart';

class SearchProfileContainerModel {
  final String name;
  final int grade;
  final String major;
  final StudentRole studentRole;

  const SearchProfileContainerModel({
    required this.name,
    required this.grade,
    required this.major,
    required this.studentRole,
});
}